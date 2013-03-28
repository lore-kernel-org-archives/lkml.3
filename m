Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab3C1Lf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 07:35:26 -0400
Received: from mail-ia0-f178.google.com ([209.85.210.178]:60244 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab3C1LfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 07:35:25 -0400
MIME-Version: 1.0
In-Reply-To: <51538701.60409@wwwdotorg.org>
References: <1364222843-30305-1-git-send-email-richard.genoud@gmail.com>
 <1364222843-30305-5-git-send-email-richard.genoud@gmail.com> <51538701.60409@wwwdotorg.org>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Thu, 28 Mar 2013 12:35:04 +0100
Message-ID: <CACQ1gAjZjcBzW5dEBYL3LzbkCq+Bj1g3jCGk1o8OMsZ9T8RH2w@mail.gmail.com>
Subject: Re: [PATCH 4/4] pinctrl: re-enable old state in case of error in pinctrl_select_state
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/28 Stephen Warren <swarren@wwwdotorg.org>:
> On 03/25/2013 08:47 AM, Richard Genoud wrote:
>> If a new state is applied, the groups configured in the old state but
>> not in the new state are disabled.
>> If something goes wrong and the new state can't be applied, we have to
>> re-enable those groups.
>
> What is the use-case for this? I wonder if it isn't better to simply
> undo the partial selection of the new state (as patch 3/4 attempts to
> do) and then leave p->state==NULL, indicating that no state is actively
> selected. IIRC, this would be the same as right after the initial
> pinctrl_select().
>
> I wonder if it's likely that attempting to re-apply the old state would
> actually work, given that applying something just failed.
>
> Finally, this recovery code doesn't:
>
> a) Process anything except MUX_GROUP; any pin config settings in the old
> state aren't restored.
>
> b) (I think) Apply any mux settings that don't involve groups that are
> referenced by both the old and new states; given that patch 3/4 attempts
> to undo everything in the failed application of the new state, I think
> this "re-apply the old state" code should simple run through everything
> in the old state any apply it unconditionally.
Well, I'm not comfortable enough with this code to argue on that...

> c) Set p->state = oldstate, so it's left at NULL, which would confuse
> any future pinctrl_select().
Arrrggg !
I forgot it !
I'll send a fix on that


-- 
for me, ck means con kolivas and not calvin klein... does it mean I'm a geek ?
