Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab3IZGbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:31:37 -0400
Received: from intranet.asianux.com ([58.214.24.6]:55919 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab3IZGbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:31:35 -0400
X-Spam-Score: -100.8
Message-ID: <5243D487.8000602@asianux.com>
Date: Thu, 26 Sep 2013 14:30:31 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH] kernel/groups.c: consider about NULL for 'group_info'
 in all related extern functions
References: <5212DBFA.8030805@asianux.com> <20130923150625.GB14547@htj.dyndns.org> <52410A40.1000304@asianux.com> <20130924040601.GA31575@mtj.dyndns.org> <524114B8.3070903@asianux.com> <20130924120429.GA2366@htj.dyndns.org> <5242331B.4010309@asianux.com> <20130925005802.GA25777@htj.dyndns.org> <5242372C.4010509@asianux.com> <20130925011404.GB25777@htj.dyndns.org> <52424094.3020504@asianux.com> <524267CD.4030007@asianux.com> <5243CD18.1060805@asianux.com>
In-Reply-To: <5243CD18.1060805@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 01:58 PM, Chen Gang wrote:
> On 09/25/2013 12:34 PM, Chen Gang wrote:
>> On 09/25/2013 09:47 AM, Chen Gang wrote:
>>> On 09/25/2013 09:14 AM, Tejun Heo wrote:
>>>> On Wed, Sep 25, 2013 at 09:06:52AM +0800, Chen Gang wrote:
>>>>> OK, I see, the 'root cause' is: "you are not the related maintainer
>>>>> either", so it is really necessary for me to spend additional time
>>>>> resource on it :-(.
>>>>
>>>> Yeah, at least partly.  That and the fact that I'm not too willing to
>>>> dig into the code without further evidence.  It isn't anything strange
>>>> to ask tho and I'm likely to do that even for subsystems that I know
>>>> intimately if the subject code has been stable / stale for years and
>>>> the analysis doesn't seem immediately convincing.  And, if my
>>>> experience is anything to go by, it's not too unlikely that you might
>>>> hit something which doesn't agree with your current assumptions while
>>>> trying to actually trigger the problem.
>>>>
>>>> Thanks.
>>>>
> 
> Oh, not cause issue, the reason is "'groups' exports extern variable
> 'init_groups', when start process, default 'cred' will set it to be
> sure of groups always be initialized".
> 
> Hmm... but after all, I still think this file need be improved: "remove
> the group_info checking in groups_search()", please help check, thanks.
> 
> -------------------------------patch begin------------------------------
> 
> kernel/groups.c: remove useless "!group_info" checking in groups_search().
> 
>   Since groups_free() need not check 'group_info', groups_search() need
>   not, either, and then in_group_p() and in_egroup_p(), either.
> 
> 
>   'groups' assumes kernel mode callers are sure of 'group_info' valid.
> 

Oh, need use "callers" instead of "kernel mode callers".

>   When process starts, the related kernel mode caller need set default
>   'group_info' firstly (extern variable 'init_group').
>
 
And also need append one sentence: "and the callers also need be sure
of "&init_group" is not passed to groups_free()."


>   If groups_alloc() fails, the caller must not call any related API again
>   with the related invalid 'group_info'.
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/groups.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/groups.c b/kernel/groups.c
> index 90cf1c3..0a7f81d 100644
> --- a/kernel/groups.c
> +++ b/kernel/groups.c
> @@ -136,9 +136,6 @@ int groups_search(const struct group_info *group_info, kgid_t grp)
>  {
>  	unsigned int left, right;
>  
> -	if (!group_info)
> -		return 0;
> -
>  	left = 0;
>  	right = group_info->ngroups;
>  	while (left < right) {
> 


-- 
Chen Gang

-- 
Chen Gang
