Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176AbaDHPqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:46:07 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.13]:56195 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756199AbaDHPqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:46:05 -0400
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Apr 2014 11:46:03 EDT
X-Env-Sender: Benjamin.Romer@unisys.com
X-Msg-Ref: server-12.tower-29.messagelabs.com!1396971583!27214717!11
X-Originating-IP: [192.61.61.105]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
From: "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
To: Fengguang Wu <fengguang.wu@intel.com>
CC: *S-Par-Maintainer <SParMaintainer@unisys.com>, Ken Cox <jkc@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Jet Chen <jet.chen@intel.com>
Date: Tue, 8 Apr 2014 10:39:36 -0500
Subject: Re: [visorchipset] invalid opcode: 0000 [#1] PREEMPT SMP
Thread-Topic: [visorchipset] invalid opcode: 0000 [#1] PREEMPT SMP
Thread-Index: Ac9TQL9IhLJhkNqLQV658EeU56CpUg==
Message-ID: <C97001BC43954D438ACB059713BA5CDF92040F0F01@USEA-EXCH7.na.uis.unisys.com>
References: <20140407111725.GC25152@localhost>
 <C97001BC43954D438ACB059713BA5CDF92040F0F00@USEA-EXCH7.na.uis.unisys.com>
 <20140408025329.GB16434@localhost>
In-Reply-To: <20140408025329.GB16434@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s38FkIe3012127

On Tue, 2014-04-08 at 10:53 +0800, Fengguang Wu wrote:
> Hi Benjamin,
> 
> > Fengguang,
> > 
> > I ran your script against freshly-checked-out source from staging-next, and was not able to reproduce the error with it. My boot log is attached. I noticed that your log did not have "Hypervisor detected: KVM" in the trace. The KVM options in your script also differ substantially from the ones shown at the end of your trace...
>  
> > When I reran your script with the "-cpu Haswell,+smep,+smap" option I was able to get the same result as you. IMHO KVM should not be setting this bit if it's emulating bare metal.
> 
> Sorry.. We tried to provide a simplified reproduce script and in your
> case, it has a significant mismatch with the real KVM options. We'll
> fix it, thanks for pointing it out!
> 
> Thanks,
> Fengguang

That will be helpful, and as I mentioned, I can reproduce your results,
but I'm still not sure why a virtualized processor is giving an invalid
opcode fault on a vmcall. The Intel documentation is pretty specific
about this - IF not in VMX operation THEN #UD; ELSIF in VMX non-root
operation THEN VM exit.

Either KVM should be saying "I'm a real processor and not a virtual CPU,
really!" - in which case, the hypervisor bit should be off and vmcalls
should cause an invalid opcode fault, or, KVM should be saying "I'm a
vritualized processor!" and setting the hypervisor bit, and doing a
vmexit on vmcall instead. This seems like a KVM bug to me.

-- Ben
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
