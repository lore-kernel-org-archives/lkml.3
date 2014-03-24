Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbaCXQ75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 12:59:57 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:33417 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaCXQ7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 12:59:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140323145339.GB9156@localhost>
References: <20140320124143.GA10751@localhost> <CAErSpo7i1sD=mNd1MZ+yWrPrPJDpZx2w-L3Dj=2N+gJBqVdSzA@mail.gmail.com>
 <20140321020930.GA11451@localhost> <CAErSpo732qfH7ChKbm5a_1ukWxa97gJ6bzH4hopKdQcha_yWuQ@mail.gmail.com>
 <20140323145339.GB9156@localhost>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 24 Mar 2014 10:59:14 -0600
Message-ID: <CAErSpo70UwbgAHSVBYH9e+ynAnAsNa8wFRhiiOi1S+DNoCV87Q@mail.gmail.com>
Subject: Re: [pci] WARNING: CPU: 0 PID: 1 at drivers/gpu/drm/drm_crtc.c:94 drm_warn_on_modeset_not_all_locked()
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Stephane Eranian <eranian@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 23, 2014 at 8:53 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Hi Bjorn,
>
> On Fri, Mar 21, 2014 at 12:42:33PM -0600, Bjorn Helgaas wrote:
>> On Thu, Mar 20, 2014 at 8:09 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>> > // CC Stephane for RAPL related bug
>> >
>> > Bjorn, sorry this bug report is mis-titled. The only new bug that show
>> > up in aa11fc58dc is on rapl_pmu_init. And it shows up only 1 time, so
>> > it's hard to reproduce and the bisect is likely not accurate.  I'll
>> > retry the bisect with more repeat count. Sorry for the disturbing!
>>
>> This testing is potentially very useful, but only if we don't have
>> many false positives.  I spent a lot of time trying to figure this
>> out, and it turned out not to be a problem at all.
>
> I'm sorry for the false report! I'll be careful and improve the
> process. Currently there are many false positives in our internal
> boot error bisects. And we rely on human reviews to select good
> bisects out of the noises. In this case both the script and me made
> mistakes, which lead to the wrong report.
>
>> As a procedural question, can you help me figure out how to handle a
>> report like this?  What I *hoped* for would be:
>>
>>   - the config you used
>
> Yes.
>
>>   - the dmesg log from the newest good commit
>
> I'll attach it if the first bad commit's parent commit(s) has some
> noise errors. In this case it may help decide whether the bisect is
> wrong: in some cases one bug will hide another one; or the bug message
> may change from one to the other.
>
>>   - the dmesg log from the oldest bad commit (the one you bisected to)
>
> OK, I've fixed the script to attach it (rather than attaching the
> branch HEAD's dmesg).
>
>>   - maybe a hint about how I can reproduce the problem, e.g., the qemu
>> config I need
>
> OK, fixed the reporting script to include the QEMU commands for
> reproducing the problem.
>
>> You did supply the config, which is good.  But you only supplied one
>> dmesg log, and it doesn't seem to be from the oldest bad commit.  In
>> fact, it seems to be from some commit that isn't actually in either
>> Linus' tree or in linux-next.  So I don't know what the connection is
>> with the bad commit.
>
> Sorry the dmesg file is from the internal merge-and-testing branch's
> HEAD -- where the bisect starts.  I'll attach the first bad commit's
> dmesg instead.
>
>> What should I do to try to debug a report like this?  Where should I start?
>
> Thank you very much for the suggestions!

Excellent, thanks!  I think these will make it much easier to figure
out where to start.

Bjorn
