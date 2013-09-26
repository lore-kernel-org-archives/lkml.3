Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab3IZRgt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 13:36:49 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:35882
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751479Ab3IZRgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 13:36:46 -0400
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275dhz2dh839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1f5fh1fe8h1ff5h209eh1155h)
X-WSS-ID: 0MTQU0A-07-L8P-02
X-M-MSG: 
Message-ID: <524470A8.7090103@amd.com>
Date: Thu, 26 Sep 2013 12:36:40 -0500
From: Sherry Hurwitz <sherry.hurwitz@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: Borislav Petkov <bp@alien8.de>, Jacob Shin <jacob.shin@amd.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Issues with AMD microcode updates
References: <20130919145834.GA4298@khazad-dum.debian.net> <20130919164409.GA9427@pd.tnic> <524221A5.9070808@amd.com> <20130925134922.GA14087@khazad-dum.debian.net>
In-Reply-To: <20130925134922.GA14087@khazad-dum.debian.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 08:49 AM, Henrique de Moraes Holschuh wrote:
> On Tue, 24 Sep 2013, Sherry Hurwitz wrote:
>> You can direct AMD microcode issues to me now.
>> We are setting up some systems in the lab and trying to duplicate
>> the problem now.
> Thank you!
>
> If you're going to be taking care of AMD microcode update issues, maybe it
> would be a good idea to add your name to the MAINTAINERS file for the "AMD
> MICROCODE UPDATE SUPPORT", and remove the (dead for a while now)
> amd64-microcode@amd64.org mailing list?
>
We have failed to reproduce a hang while loading microcode.
We have tested with kernel and AMD family combinations with
normal and error condition so error paths were taken.  Obviously
there are factors we are missing that the users are hitting.
Any suggestions on how we improve the test matrix would be
helpful.  We will continue the investigation but any insights are appreciated.

NOTE: kernels before 3.0 only load 1 (2k) size of microcode patch and
therefore do not support microcode loading of family 14h, 15h, and 16h.
Also,in a test request on another thread you suggested someone with
family 15h revC0 to load microcode twice with an earlier patch and then
the latest, but there has only been 1 microcode patch level published for revB2
so that test won't work.

Test Matrix:

kernel           cpu family             results             conditions
---------------------------------------------------------------------------------
2.6.38           fam10h                 load passed         normal
2.6.38           fam15h revC0           load failed         2.6.38 can not handle 4k patches
3.5.2            fam10h                 load passed         normal
3.5.2            fam15h revB2           load passed         loaded 637 then second load 63d
3.5.2            fam15h revC0           load passed         normal
3.5.2            fam15h revC0           load failed         used a corrupted bin file
3.7              fam15h revC0           load passed         loaded  81c then second load 822
3.10             fam15h revC0           load passed         loaded 81c then second load 822
3.11rc7          fam15h revB2           load passedBIOS loaded 637; test loaded 63d; sysfs info can be misleading


