Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751425AbaEUDVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 23:21:19 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:38217 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaEUDVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 23:21:17 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
CC: Hannes Reinecke <hare@suse.de>, Prarit Bhargava <prarit@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Kay Sievers <kay@vrfy.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: RE: [PATCH RESEND] scsi: Output error messages using structured
 printk in single line
Thread-Topic: [PATCH RESEND] scsi: Output error messages using structured
 printk in single line
Thread-Index: AQHPM3Lum//6hgjKjkalevsk3IQyj5tK0AAAgAABt5A=
Date: Wed, 21 May 2014 03:18:52 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402956F1CF5A@G4W3202.americas.hpqcorp.net>
References: <20140227041738.31316.14684.stgit@yunodevel>
 <1400638922.2481.18.camel@dabdike>
In-Reply-To: <1400638922.2481.18.camel@dabdike>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.201.58.29]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of James Bottomley
> Sent: Tuesday, May 20, 2014 9:22 PM
> To: Yoshihiro YUNOMAE
> Cc: Hannes Reinecke; Prarit Bhargava; linux-scsi@vger.kernel.org; Kay
> Sievers; linux-kernel@vger.kernel.org; Hidehiro Kawai; yrl.pp-
> manager.tt@hitachi.com; Masami Hiramatsu
> Subject: Re: [PATCH RESEND] scsi: Output error messages using structured
> printk in single line
> 
> On Thu, 2014-02-27 at 13:17 +0900, Yoshihiro YUNOMAE wrote:
> > +/* Maximum size of a local buffer for structured printk */
> > +#define SCSI_LOG_LINE_MAX 512
> > +
> > +/* Local buffer for structured printk */
> > +struct scsi_log_line {
> > +	int offset;
> > +	char buf[SCSI_LOG_LINE_MAX];
> > +};
> 
> This piece isn't going to fly; it's an on stack allocation of 0.5kb;
> that's too much for small stack kernels.  Just changing this to a kalloc
> is going be problematic too because we're in the io paths and the
> allocation may fail.  So I appreciate the problem, but I don't think the
> solution works.  Could we just tag the messages and use grep to put them
> back together?
> 
> James
> 

When the system gets busy, I've seen CDB bytes strung out with each
byte getting its own timestamp, with messages from different devices
and threads interleaved together, so like the idea of printing each 
line with a single printk() call.

Most lines aren't anywhere near 512 bytes long.  Can this be coded to 
let the calling function define an appropriate buffer size for
whatever it is printing, with sizeof() used to bounds check?


