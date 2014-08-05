Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbaHEHy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 03:54:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50009 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745AbaHEHyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 03:54:25 -0400
Date: Tue, 5 Aug 2014 09:54:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        toshi.kani@hp.com, imammedo@redhat.com, jan.kiszka@siemens.com,
        mingo@kernel.org, huawei.libin@huawei.com, prarit@redhat.com,
        linux-kernel@vger.kernel.org,
        "Brandt, Todd E" <todd.e.brandt@intel.com>
Subject: Re: [PATCH] X86/CPU: Avoid 100ms sleep for cpu offline  during S3
Message-ID: <20140805075419.GA18234@pd.tnic>
References: <1407142742-29202-1-git-send-email-tianyu.lan@intel.com>
 <20140804102301.GB4808@pd.tnic>
 <53E04457.2060507@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53E04457.2060507@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tianyu,

On Tue, Aug 05, 2014 at 10:41:27AM +0800, Lan Tianyu wrote:
> Thanks for your review. We are doing S2RAM optimization.
> We usually use AnalyzeSuspend tool from Brandt, Todd E to observe
> the time consume during S2RAM.(https://github.com/01org/suspendresume.git)
> 
> I attached the original result from the tool which showed cpu offline consumes
> more than 100ms. This is due to msleep in the native_cpu_die(). The
> improvement.html shows the test result with the patch. You can't find cpu
> offline at first glance and need to click zoom-in button because the consume
> time of cpu offline is reduced to less than 5ms.

The fact that I can't find it is a good thing, right? :-)

Ok, this looks nice, it actually shows an improvement from cpus going
offline for about 100ish msec and that duration shrinking down to 1.5
msec on average which is a ~100x improv in my book.

And the total S/R time diff looks really good too.

Can people do those measurements outside of your lab? Because if they
can, I could do some on my boxes here too :)

Now, what you could do is run this on a couple of systems, if possible,
write down in the commit message how exactly you did it and add some
relevant numbers to show the speedup. Because this completion thing is
definitely worth pursuing further, provided it doesn't break suspend in
some weird ways.

Btw, the original patches which added the 100ms msleep are:

	ef6e525393db ("[PATCH] x86_64: Use msleep in smpboot.c")
	aeb8397b6a28 ("[PATCH] i386/smpboot: use msleep() instead of schedule_timeout()")

and its commit message is, of course, :-( not very telling. WTF does
"task delays as expected" mean? I have to go poke peterz for an idea
what it might've meant...

So do you see what I mean with writing a good, verbose commit message,
explaining the situation?

It needs to explain not what we did but why we did it years from now so
that we know exactly if we have to go touch that code again.

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
