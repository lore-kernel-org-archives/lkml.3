Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab3E1TCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 15:02:01 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:35379 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab3E1TCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 15:02:00 -0400
Message-ID: <51A4FF25.8040908@linaro.org>
Date: Tue, 28 May 2013 12:01:57 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: xen-devel@lists.xen.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/xen: sync the CMOS RTC as well as the Xen wallclock
References: <1369765368-10823-1-git-send-email-david.vrabel@citrix.com> <1369765368-10823-2-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1369765368-10823-2-git-send-email-david.vrabel@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 11:22 AM, David Vrabel wrote:
> From: David Vrabel <david.vrabel@citrix.com>
>
> Adjustments to Xen's persistent_clock via update_persistent_clock()
> don't actually persist, as the xen_set_walltime() just notifies other
> domN guests that it has been updated, and does not modify the
> underlying CMOS clock.
>
> Thus, this patch modifies xen_set_wallclock() so it will set the
> underlying CMOS clock when called from dom0, ensuring the
> persistent_clock will be correct on the next hardware boot.
>
> Dom0 does not support accessing EFI runtime services and Xen does not
> run on Moorsetown platforms so the CMOS RTC is the only supported
> hardware clock.
>
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Ok, I've queued this for 3.11.

thanks
-john

