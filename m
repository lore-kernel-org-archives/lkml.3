Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbaJGMF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:05:28 -0400
Received: from rrzmta1.uni-regensburg.de ([194.94.155.51]:59613 "EHLO
	rrzmta1.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbaJGMFY convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:1:1>);
	Tue, 7 Oct 2014 08:05:24 -0400
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Oct 2014 08:05:23 EDT
Message-Id: <5433F1CC020000A100017471@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Tue, 07 Oct 2014 13:59:40 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: Q: EDAC/kprintf/Xen issue (long logs inline)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I have a somewhat strange isse on a Xen host running SLES11 SP3 on a HP DL380 G7 server (two 5-core Xeon 5650 CPUs): At some time the system had RAM problems, and in one case the messages seemed to overwrite each other as seen in syslog. I wonder whether the locking of kprintf() is broken. See yourself:

Mar 14 10:06:40 h05 kernel: [679593.489003] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:40 h05 kernel: [679593.489010] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:40 h05 kernel: [679593.489014] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:40 h05 kernel: [679593.489019] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:40 h05 kernel: [679593.489023] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:40 h05 kernel: [679593.489027] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:40 h05 kernel: [679593.489031] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
[...and so on...]
Mar 14 10:06:41 h05 kernel: [679593.501561] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.501568] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.501575] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.501583] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.501590] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.501597] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.501604] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.501611] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.501618] EDAC MC1: CE rohannel 0, label "": Corrected error (Socket=1hannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1hanne
l 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.501647] EDAhannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=hannel 0, label "": Corrected error (Socket=1 chhannel 0, label
"": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected
 error (Socket=1 hannel 0, label "": Corrected error (Socket=1hannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1
hannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 hannel 0, label
 "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1hannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected e
rror (Socket=1
Mar 14 10:06:41 h05 kernel:  hannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected err
or (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.501830] EDAC MC1: CE row 6, channehannel 0, label "": Corrected error (Socket=1 chanhannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error
 (Socket=1 hannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1 h
annel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1 hannel 0, label
"": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=hannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected er
ror (Socket=1 channel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1
hannel 0, labe
Mar 14 10:06:41 h05 kernel: l "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=han
nel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 hannel 0, label ""
: Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected
 error (Socket=1 channel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Sock
et=1 chahannel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.502074] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Sockehannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1 cha
hannel 0, label "": Corrected error (Sohannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chahannel 0, label "":
 Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected er
ror (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.502135] EDAC hannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1 chhannel 0, l
abel "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.502159] EDAChannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chhannel 0,
label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Co
rrected error (Socket=1 channel 0, label "": Corrected error (Sochannel 0, label "": Corrected error (Socket=1 channelhannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error
 (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1
 chhannel 0, label "":hannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Sockehannel 0, label "": Corrected error (Socket
=1 chahannel 0
Mar 14 10:06:41 h05 kernel: , label "": Corrected error (Socket=1hannel 0, label "": Correctedhannel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.502258] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.502262] EDAC MC1: CE row 6, channel 0, label "": Corrected errhannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 channel=2
dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.502275] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.502281] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Shannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chhann
el 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 chhannel 0, label
 "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.502314] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.502318] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.502322] EDAC MC1:hannel 0, label "": Corrected error (Socket=1 chanhannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chhann
el 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.502342] EDAChannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0, la
bel "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 channel 0, label "": Co
rrected error (Sockethannel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.502379] EDAhannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0, la
bel "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corre
cted error (Socket=1 channel 0, label "": Corrected error (Socket=1 chanhannel 0, label "": Corrected errorhannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 ch
hannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 channel=2 di
mm=0)
Mar 14 10:06:41 h05 kernel: [679593.502448] EDAhannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.502456] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.50hannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 channel 0, label "":
Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chanhannel 0, label "": Corrected
 error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Sochannel 0, label "": Corrected error (Socket=1
 chahannel 0, label "": Corrected error (Sockethannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channehannel 0,
 label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channehannel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.502544] EDAChannel 0, label "": Corrected error (Sockethannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chhannel 0, label
"": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Sockhannel 0, label "": Corrected err
or (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Sockehannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 cha
nnel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.502600] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [67959hannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0, label "": Corre
cted error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected erro
r (Socket=1 chhannel 0, label "": Corrected error (Sockhannel 0, label "": Corrected error (Sockethannel 0, label "": Corrected error (Socket=1 channhannel 0, label "": Corrected error (Socket=1 chanhan
nel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1 chahannel 0, label
 "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Correc
ted error (Soc
Mar 14 10:06:41 h05 kernel: ket=1 chhannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Cor
rected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (S
ocket=1 hannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 cha
nnel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1 chahannel 0, lab
el "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0, label "": Correc
ted error (Socket
Mar 14 10:06:41 h05 kernel: =1 channel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0, label "": Correcte
d error (Socket=1 channel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Sock
et=1 channel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 channel
 0, label "": Corrected error (Socket=hannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Sochannel 0, label "": Corrected error (Sockehannel 0, label "": Corrected error
 (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Sochan
nel 0, label "":
Mar 14 10:06:41 h05 kernel: Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chanhannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chh
annel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 channel 0, la
bel "": Corrected error (Sochannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Sohannel 0, label "": Corrected error (So
cket=1 chhannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Sockhannel 0, label "": Corrected error (Socket=1 channel 0,
label "": Corrected error (Sockethannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 channel 0, label "": Correc
ted error (Socket
Mar 14 10:06:41 h05 kernel: =1 channel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 channel 0, label "": Correct
ed error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Soc
ket=1 chhannel 0, label "": Corrected error (Socket=1hannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0
, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Sockhannel 0, label "": Correc
ted error (Sockehannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Sockethannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 c
hannel 0, label "
Mar 14 10:06:41 h05 kernel: ": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chanhannel 0, label "": Corrected error (Socket=1
channhannel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503068] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [67959hannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503082] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503086] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 chanhannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (S
ocket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.5031hannel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503104] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Sochannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 cha
nnel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503116] EDAChannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Sockehannel 0, label "": Corrected error (Socket=1 chahannel 0, label
"": Corrected error (Socket=1hannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected e
rror (Socket=hannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1 c
hannel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503170] EDAC Mhannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 channel 0,
 label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0, label "": C
orrected error (Socket=1 chanhannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503213] EDAhannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0, lab
el "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Sockehannel 0, label "": Corrected er
ror (Socket=1 chhannel 0, label "": Corrected error (Sockethannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 c
hhannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 chhannel 0,
label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 chhannel 0, label "":
Corrected erro
Mar 14 10:06:41 h05 kernel: r (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 chhannel 0, label
 "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Correcte
d error (Socket=1 hannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (S
ocket=1 hannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chan
nel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Socket=1 chanhannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 chahannel 0,
label "": Correct
Mar 14 10:06:41 h05 kernel: ed error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503386] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
[...]
Mar 14 10:06:41 h05 kernel: [679593.503646] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679hannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1hannel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503664] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503668] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.50hannel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503676] hannel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503681] EDhannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503689] EDAhannel 0, label "": Corrected error (Sockehannel 0, label "": Channel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Socket=
1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503715] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503719] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503723] EDAChannel 0, label "": Corrected error (Socket=1hannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503734] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: hannel 0, label "": Corrected error (Socket=1hannel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503747] EDAC MC1: CE row 6, channel 0, label "": Corrected ehannel 0, label "": Corrected error (Socket=1 channehannel 0, label "": Corrected error (Sockhannel 0, lab
el "": Corrected error (Socket=1 chanhannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected error (Sochannel 0, label "": Corrected error (Socket=1 chhannel 0, label "": Corrected
 error (Socket=hannel 0, label "": Corrected error (Socket=1 hannel 0, label "": Corrected error (Sockehannel 0, label "": Corrected error (Socket=1 chahannel 0, label "": Corrected error (Sockhannel 0,
 label "": Corrected error (Sochannel 0, label "": Corrected error (Socket=1 chanhannel 0, label "": Corrected error (Sockethannel 0, label "": Corrected error (Socket=1hannel 0, label "": Corrected err
or (Socket=1 chhannel 0, label "": Corrected error (Sockehannel 0, label "": Corrected error (Socket=1hannel 0, label "": Corrected error (Socket=1 channel 0, label "": Corrected error (Socket=1 channel
=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503841] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503845] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503849] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503853] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503857] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503861] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503865] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
Mar 14 10:06:41 h05 kernel: [679593.503869] EDAC MC1: CE row 6, channel 0, label "": Corrected error (Socket=1 channel=2 dimm=0)
[...]


On a non-Xen host (same hardware) I don't see this kind of message corruption:
Jan 17 01:05:11 h04 kernel: [2724087.160257] EDAC MC0: CE row 2, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=2)
[...]
Aug 13 05:01:40 h04 kernel: [2797680.835057] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 05:01:40 h04 kernel: [2797680.835064] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 05:01:40 h04 kernel: [2797680.835068] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 05:01:40 h04 kernel: [2797680.835073] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
[...]
Aug 13 05:58:28 h04 kernel: [2801088.028505] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 05:58:28 h04 kernel: [2801088.028511] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 06:00:01 h04 kernel: [2801180.743866] CMCI storm detected: switching to poll mode
Aug 13 06:00:01 h04 kernel: [2801181.003188] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 06:00:01 h04 kernel: [2801181.003194] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 06:00:01 h04 kernel: [2801181.003198] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 06:00:01 h04 kernel: [2801181.003202] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
[...]
Aug 13 06:00:02 h04 kernel: [2801182.003227] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 06:00:02 h04 kernel: [2801182.003230] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 06:00:02 h04 kernel: [2801182.003232] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 06:00:02 h04 kernel: [2801182.003234] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 06:00:07 h04 kernel: [2801187.001381] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 06:00:16 h04 kernel: [2801195.998847] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 06:00:24 h04 kernel: [2801203.900612] CMCI storm subsided: switching to interrupt mode
Aug 13 06:00:24 h04 kernel: [2801203.900618] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 CMCI:8
Aug 13 06:00:24 h04 kernel: [2801204.000640] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 06:00:53 h04 kernel: [2801232.916638] CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5
Aug 13 06:00:54 h04 kernel: [2801233.652425] CPU 22 MCA banks CMCI:2 CMCI:3 CMCI:5
Aug 13 06:00:54 h04 kernel: [2801233.676407] CPU 20 MCA banks CMCI:2 CMCI:3 CMCI:5
Aug 13 06:00:54 h04 kernel: [2801233.701573] CPU 18 MCA banks CMCI:2 CMCI:3 CMCI:5
Aug 13 06:00:54 h04 kernel: [2801233.724421] CPU 16 MCA banks CMCI:2 CMCI:3 CMCI:5
Aug 13 06:01:46 h04 kernel: [2801285.986361] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 06:01:46 h04 kernel: [2801285.986368] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 06:01:46 h04 kernel: [2801285.986372] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 06:01:46 h04 kernel: [2801285.986376] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 06:01:47 h04 kernel: [2801286.985912] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
[...]
Aug 13 07:54:17 h04 kernel: [2808034.584062] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 07:54:17 h04 kernel: [2808034.584064] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 07:54:17 h04 kernel: [2808034.584067] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 07:54:17 h04 kernel: [2808034.584069] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 07:54:17 h04 kernel: [2808034.584071] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 07:54:17 h04 kernel: [2808034.931978] CMCI storm detected: switching to poll mode
Aug 13 07:54:18 h04 kernel: [2808035.583593] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 07:54:18 h04 kernel: [2808035.583599] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 07:54:18 h04 kernel: [2808035.583603] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 07:54:18 h04 kernel: [2808035.583607] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 07:54:18 h04 kernel: [2808035.583612] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
[...]
Aug 13 07:54:18 h04 kernel: [2808035.583653] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 07:54:18 h04 kernel: [2808035.583657] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 07:54:23 h04 kernel: [2808040.582274] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 07:54:47 h04 kernel: [2808064.923646] CMCI storm subsided: switching to interrupt mode
Aug 13 07:54:47 h04 kernel: [2808064.923656] CPU 22 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 CMCI:8
Aug 13 07:55:17 h04 kernel: [2808094.915444] CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5
Aug 13 07:55:17 h04 kernel: [2808094.915455] CPU 20 MCA banks CMCI:2 CMCI:3 CMCI:5
Aug 13 07:55:17 h04 kernel: [2808094.915473] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5
Aug 13 07:55:17 h04 kernel: [2808094.915688] CPU 4 MCA banks CMCI:2 CMCI:3 CMCI:5
Aug 13 07:55:17 h04 kernel: [2808094.915842] CPU 6 MCA banks CMCI:2 CMCI:3 CMCI:5
Aug 13 07:55:54 h04 kernel: [2808131.557694] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 07:55:54 h04 kernel: [2808131.557700] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 07:55:54 h04 kernel: [2808131.557704] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
[...]
Aug 13 08:42:09 h04 kernel: [2810906.123879] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 08:42:09 h04 kernel: [2810906.123881] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 08:42:09 h04 kernel: [2810906.123883] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 08:42:09 h04 kernel: [2810906.123886] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 08:42:09 h04 kernel: [2810906.368343] CMCI storm detected: switching to poll mode
Aug 13 08:42:10 h04 kernel: [2810907.123636] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 08:42:10 h04 kernel: [2810907.123643] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 08:42:10 h04 kernel: [2810907.123648] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 08:42:10 h04 kernel: [2810907.123652] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
[...]
Aug 13 08:42:13 h04 kernel: [2810910.122787] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 08:42:13 h04 kernel: [2810910.122791] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 08:42:13 h04 kernel: [2810910.122795] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 08:42:13 h04 kernel: [2810910.122800] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 08:42:39 h04 kernel: [2810936.360923] CMCI storm subsided: switching to interrupt mode
Aug 13 08:42:39 h04 kernel: [2810936.360932] CPU 20 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 CMCI:8
Aug 13 08:42:47 h04 kernel: [2810944.009597] CPU 22 MCA banks CMCI:2 CMCI:3 CMCI:5
Aug 13 08:43:00 h04 kernel: [2810957.118128] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 08:43:00 h04 kernel: [2810957.118132] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 08:43:09 h04 kernel: [2810966.351528] CPU 16 MCA banks CMCI:2 CMCI:3 CMCI:5
Aug 13 08:43:09 h04 kernel: [2810966.351563] CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5
Aug 13 08:43:09 h04 kernel: [2810966.351580] CPU 18 MCA banks CMCI:2 CMCI:3 CMCI:5
Aug 13 08:43:09 h04 kernel: [2810966.351692] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5
Aug 13 08:44:14 h04 kernel: [2811031.102138] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 08:44:14 h04 kernel: [2811031.102142] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 08:44:14 h04 kernel: [2811031.102145] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
[...]
Aug 13 10:22:33 h04 kernel: [2816928.092940] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:26:10 h04 kernel: [2817145.046007] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:26:17 h04 kernel: [2817152.044197] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:26:52 h04 kernel: [2817187.050696] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:30:18 h04 kernel: [2817393.365271] CMCI storm detected: switching to poll mode
Aug 13 10:30:19 h04 kernel: [2817394.042582] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:30:19 h04 kernel: [2817394.042588] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:30:19 h04 kernel: [2817394.042592] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
[...]
Aug 13 10:30:48 h04 kernel: [2817423.042713] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:30:48 h04 kernel: [2817423.042715] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:30:48 h04 kernel: [2817423.042717] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:30:48 h04 kernel: [2817423.042720] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:30:48 h04 kernel: [2817423.042722] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:30:48 h04 kernel: [2817423.042724] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:30:48 h04 kernel: [2817423.354451] CMCI storm subsided: switching to interrupt mode
Aug 13 10:30:48 h04 kernel: [2817423.354456] CPU 20 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 CMCI:8
Aug 13 10:30:48 h04 kernel: [2817423.553247] CMCI storm detected: switching to poll mode
Aug 13 10:30:49 h04 kernel: [2817424.046318] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:30:49 h04 kernel: [2817424.046321] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:30:49 h04 kernel: [2817424.046324] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:30:49 h04 kernel: [2817424.046326] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:30:49 h04 kernel: [2817424.046328] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
[...]
Aug 13 10:31:18 h04 kernel: [2817453.046749] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:31:18 h04 kernel: [2817453.046751] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:31:18 h04 kernel: [2817453.046753] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:31:18 h04 kernel: [2817453.046755] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:31:18 h04 kernel: [2817453.543102] CMCI storm subsided: switching to interrupt mode
Aug 13 10:31:18 h04 kernel: [2817453.543108] CPU 14 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 CMCI:8
Aug 13 10:31:19 h04 kernel: [2817453.729057] CMCI storm detected: switching to poll mode
Aug 13 10:31:19 h04 kernel: [2817454.047029] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:31:19 h04 kernel: [2817454.047033] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:31:19 h04 kernel: [2817454.047036] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:31:19 h04 kernel: [2817454.047039] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:31:19 h04 kernel: [2817454.047042] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
[...]
Aug 13 10:31:45 h04 kernel: [2817480.043281] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:31:45 h04 kernel: [2817480.043286] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:31:45 h04 kernel: [2817480.043290] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:31:45 h04 kernel: [2817480.043295] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:31:49 h04 kernel: [2817483.718417] CMCI storm subsided: switching to interrupt mode
Aug 13 10:31:49 h04 kernel: [2817483.718426] CPU 6 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 CMCI:8
Aug 13 10:32:03 h04 kernel: [2817498.038262] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:32:03 h04 kernel: [2817498.038265] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:32:03 h04 kernel: [2817498.038271] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:32:04 h04 kernel: [2817499.037942] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:32:04 h04 kernel: [2817499.037948] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:32:09 h04 kernel: [2817504.404466] CPU 8 MCA banks CMCI:2 CMCI:3 CMCI:5
Aug 13 10:32:18 h04 kernel: [2817513.526004] CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5
Aug 13 10:32:18 h04 kernel: [2817513.526029] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5
Aug 13 10:32:19 h04 kernel: [2817513.709916] CPU 16 MCA banks CMCI:2 CMCI:3 CMCI:5
Aug 13 10:32:19 h04 kernel: [2817513.709945] CPU 22 MCA banks CMCI:2 CMCI:3 CMCI:5
Aug 13 10:32:42 h04 kernel: [2817537.027747] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:33:16 h04 kernel: [2817570.937450] CMCI storm detected: switching to poll mode
Aug 13 10:33:16 h04 kernel: [2817571.026519] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:33:16 h04 kernel: [2817571.026525] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:33:16 h04 kernel: [2817571.026529] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
[...]
Aug 13 10:33:45 h04 kernel: [2817600.034964] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:33:45 h04 kernel: [2817600.034968] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:33:45 h04 kernel: [2817600.034972] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:33:45 h04 kernel: [2817600.034976] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:33:46 h04 kernel: [2817600.926265] CMCI storm subsided: switching to interrupt mode
Aug 13 10:33:46 h04 kernel: [2817600.926274] CPU 18 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 CMCI:8
Aug 13 10:33:46 h04 kernel: [2817601.034923] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:33:46 h04 kernel: [2817601.034927] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:33:46 h04 kernel: [2817601.034930] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:33:46 h04 kernel: [2817601.034932] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
[...]
Aug 13 10:33:46 h04 kernel: [2817601.035080] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:33:46 h04 kernel: [2817601.035082] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:33:46 h04 kernel: [2817601.035084] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:33:46 h04 kernel: [2817601.035086] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:33:46 h04 kernel: [2817601.142363] CMCI storm detected: switching to poll mode
Aug 13 10:33:47 h04 kernel: [2817602.034580] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:33:47 h04 kernel: [2817602.034587] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:33:47 h04 kernel: [2817602.034591] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:33:47 h04 kernel: [2817602.034595] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:33:47 h04 kernel: [2817602.034599] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
[...]
Aug 13 10:34:16 h04 kernel: [2817631.026523] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:34:16 h04 kernel: [2817631.026528] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:34:16 h04 kernel: [2817631.026532] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:34:16 h04 kernel: [2817631.026536] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:34:16 h04 kernel: [2817631.134412] CMCI storm subsided: switching to interrupt mode
Aug 13 10:34:16 h04 kernel: [2817631.134420] CPU 8 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 CMCI:8
Aug 13 10:34:16 h04 kernel: [2817631.334460] CMCI storm detected: switching to poll mode
Aug 13 10:34:17 h04 kernel: [2817632.026573] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:34:17 h04 kernel: [2817632.026577] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:34:17 h04 kernel: [2817632.026579] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
[...]
Aug 13 10:34:42 h04 kernel: [2817657.019136] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:34:42 h04 kernel: [2817657.019139] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:34:42 h04 kernel: [2817657.019141] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:34:42 h04 kernel: [2817657.019143] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:34:42 h04 kernel: [2817657.019145] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:34:42 h04 kernel: [2817657.019147] EDAC MC0: CE row 0, channel 0, label "": Corrected error (Socket=0 channel=0 dimm=0)
Aug 13 10:34:46 h04 kernel: [2817661.327218] CMCI storm subsided: switching to interrupt mode
Aug 13 10:34:46 h04 kernel: [2817661.327224] CPU 22 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6 CMCI:8
Aug 13 10:34:48 h04 kernel: [2817663.289320] CPU 20 MCA banks CMCI:2 CMCI:3 CMCI:5
Aug 13 10:34:49 h04 kernel: [2817663.669468] CPU 4 MCA banks CMCI:2 CMCI:3 CMCI:5
Aug 13 10:34:49 h04 kernel: [2817663.669612] CPU 6 MCA banks CMCI:2 CMCI:3 CMCI:5
Aug 13 10:35:16 h04 kernel: [2817691.317774] CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5
Aug 13 10:35:16 h04 kernel: [2817691.317837] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5
[...no more EDAC messages since then...]

Kernel on this machine is "kernel-default-3.0.101-0.31.1". CPU details:
processor       : 23
vendor_id       : GenuineIntel
cpu family      : 6
model           : 44
model name      : Intel(R) Xeon(R) CPU           X5650  @ 2.67GHz
stepping        : 2
microcode       : 26

I feel the EDAC log messages are not very informative, and I feel these messages should be throttled and summarized somehow.

Regards,
Ulrich

