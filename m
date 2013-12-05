Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab3LEShw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:37:52 -0500
Received: from service87.mimecast.com ([91.220.42.44]:57946 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756969Ab3LEShu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:37:50 -0500
Message-ID: <52A0C800.90302@arm.com>
Date: Thu, 05 Dec 2013 18:37:52 +0000
From: Serban Constantinescu <Serban.Constantinescu@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arve@android.com" <arve@android.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "ccross@android.com" <ccross@android.com>,
        Dave Butcher <Dave.Butcher@arm.com>,
        "irogers@google.com" <irogers@google.com>,
        "romlem@android.com" <romlem@android.com>
Subject: Re: [PATCH v1 1/9] staging: android: binder: Move some of the logic
 into subfunction
References: <1386180581-6710-1-git-send-email-serban.constantinescu@arm.com> <1386180581-6710-2-git-send-email-serban.constantinescu@arm.com> <20131205080050.GT28413@mwanda>
In-Reply-To: <20131205080050.GT28413@mwanda>
X-OriginalArrivalTime: 05 Dec 2013 18:37:46.0615 (UTC) FILETIME=[179CD070:01CEF1E9]
X-MC-Unique: 113120518374800201
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/13 08:00, Dan Carpenter wrote:
> On Wed, Dec 04, 2013 at 06:09:33PM +0000, Serban Constantinescu wrote:
>> +static void bc_dead_binder_done(struct binder_proc *proc,
>> +		    struct binder_thread *thread, void __user *cookie)
>> +{
>> +	struct binder_work *w;
>> +	struct binder_ref_death *death = NULL;
>> +
>> +	list_for_each_entry(w, &proc->delivered_death, entry) {
>> +		struct binder_ref_death *tmp_death = container_of(w, struct binder_ref_death, work);
>
> Put a blank line after the variable declaration block.  Also break it up
> into two lines instead of having the lines be a million characters long.

I will do that, I have followed the same conventions used by the code 
allready there.

>
> 	list_for_each_entry(w, &proc->delivered_death, entry) {
> 		struct binder_ref_death *tmp_death;
>
> 		tmp_death = container_of(w, struct binder_ref_death, work);
>
>> +		if (tmp_death->cookie == cookie) {
>> +			death = tmp_death;
>> +			return;
>
> Should be a break here.  This function wasn't tested.

There should be a break there! I have tested the driver with 32bit 
Android tests, none of which seem to hit this.

Thanks for your review,
Serban C

