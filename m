Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbaETLZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 07:25:45 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:49452 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaETLZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 07:25:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAOqmu80avjT8cjKPLL-JFbP4w8dWqbfSTJQW9XDd16UviSSRDQ@mail.gmail.com>
References: <1400231366-1221-1-git-send-email-inderpal.s@samsung.com>
	<537A037E.8000800@ti.com>
	<CAOqmu83XqC_B1Abb_+FMc=DywUxL0=_NompWB4ED18UhxxqQNw@mail.gmail.com>
	<CAGo_u6p+XWfQU64Uvbd2-5u5DumoSo1XsDt_s48MF5yXYZDBxA@mail.gmail.com>
	<CAOqmu80avjT8cjKPLL-JFbP4w8dWqbfSTJQW9XDd16UviSSRDQ@mail.gmail.com>
Date: Tue, 20 May 2014 06:25:42 -0500
X-Google-Sender-Auth: -ybbJkN6EDQ9Xa4g0-2-MyDnUt4
Message-ID: <CAGo_u6pZqp92yNXSmAkjH6FzQyroaAFMJjFRAVjcDBU7H_YgNw@mail.gmail.com>
Subject: Re: [PATCH] PM / OPP: Implement free_opp_table function
From: Nishanth Menon <nm@ti.com>
To: Inderpal Singh <inderpal.s@samsung.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 12:36 AM, Inderpal Singh <inderpal.s@samsung.com> wrote:
> On Tue, May 20, 2014 at 12:04 AM, Nishanth Menon <nm@ti.com> wrote:
>> On Mon, May 19, 2014 at 1:08 PM, Inderpal Singh <inderpal.s@samsung.com> wrote:
>>> Hi Nishanth,
>>>
>>> Thanks for the review comments.
>>>
>>> On Mon, May 19, 2014 at 6:43 PM, Nishanth Menon <nm@ti.com> wrote:
>>>> On 05/16/2014 04:09 AM, Inderpal Singh wrote:

[..]
>>>>> +     /* Hold our list modification lock here */
>>>>> +     mutex_lock(&dev_opp_list_lock);
>>>>> +
>>>>> +     /* Check for existing list for 'dev' */
>>>>> +     dev_opp = find_device_opp(dev);
>>>>> +     if (IS_ERR(dev_opp)) {
>>>>> +             mutex_unlock(&dev_opp_list_lock);
>>>>> +             return;
>>>>> +     }
>>>>> +
>>>>> +     while (!list_empty(&dev_opp->opp_list)) {
>>>>> +             opp = list_entry_rcu(dev_opp->opp_list.next,
>>>>> +                                     struct dev_pm_opp, node);
>>>>> +             list_del_rcu(&opp->node);
>>>>> +             kfree_rcu(opp, head);
>>>>> +     }
>>>>
>>>> How about the OPP notifiers? should'nt we add a new event
>>>> OPP_EVENT_REMOVE?
>>>>
>>>
>>> As this function is to free the whole opp table. Hence, I think,
>>> notifier may not be needed. It may be required for per opp removal as
>>> is the case with opp addition and enable/disable. But at present there
>>> are no users of these notifiers at all. Let me know your view.
>>
>> umm.. we do have devfreq which depends on OPPs :).
>
> Yes, devfreq does depend on OPPs, but no devfreq driver is registering
> its notifier_block to handle OPP notifications.
>

Lets not forget the power of downstream tree drivers that use the API set :)

>>
>>>> To maintain non-dt behavior coherency, should'nt we rather add a
>>>> opp_remove or an opp_del function?
>>>
>>> Yes we should have opp_remove as well, but what's the use case ?
>>> Should we go ahead and implement it Or, wait for the use-case?
>>
>> IMHO, if we are doing it properly, we should add the requisite
>> function as well. we dont want to have differing behavior device tree
>> Vs non-DT.
>
> So we will have 2 functions then. One to remove the whole opp table
> and the the other to remove the individual OPPs.
> I will cover this in v2. Will also take care of the OPP_EVENT_REMOVE
> notification part.
>

Thanks.

--
Regards,
Nishanth Menon
