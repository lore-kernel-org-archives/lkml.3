Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab3BLWAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:00:05 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:45057 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab3BLWAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:00:03 -0500
Message-ID: <511ABB5E.2090301@suse.cz>
Date: Tue, 12 Feb 2013 22:59:58 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: compositing broken in -next (idr bug)
References: <511ABA59.9050604@suse.cz> <20130212215806.GB9057@htj.dyndns.org>
In-Reply-To: <20130212215806.GB9057@htj.dyndns.org>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 10:58 PM, Tejun Heo wrote:
> Hello, Jiri.
> 
> On Tue, Feb 12, 2013 at 10:55:37PM +0100, Jiri Slaby wrote:
>> this commit in -next causes my KDE to get stuck while starting. I see
>> only the splash screen. If I disable effects by alt-shift-f12, it continues.
>>
>> I bisected it to this commit:
>> commit 430440fce7da4ad52c2af06a04a5132e5d19faaf
>> Author: Tejun Heo <tj@kernel.org>
>> Date:   Thu Feb 7 12:31:37 2013 +1100
>>
>>     drm: convert to idr_alloc()
>>
>>
>> More concretely to the change in drm_gem_flink_ioctl. If I revert solely
>> that one, it works again. Maybe I'm blind, but I do not see why...
>>
>> Well I see a bug in there, but that is not the root cause -- there is a
>> missing call to idr_preload_end. Of course, that one only leaves
>> preemption disabled forever.
> 
> Fix for this bug is already queued in -mm.
> 
>   http://article.gmane.org/gmane.linux.kernel/1439101/raw
> 
> But you're saying that adding the missing idr_preload_end() doesn't
> make the problem go away, right?

Yeah, right. I had to revert the whole hunk...

-- 
js
suse labs
