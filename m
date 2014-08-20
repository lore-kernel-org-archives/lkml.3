Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbaHTRni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 13:43:38 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:33592 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbaHTRnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 13:43:35 -0400
Message-ID: <53F4DE42.40308@6wind.com>
Date: Wed, 20 Aug 2014 19:43:30 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reply-To: nicolas.dichtel@6wind.com
Organization: 6WIND
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Richard Guy Briggs <rgb@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com, serge@hallyn.com,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH V3 0/6] namespaces: log namespaces per task
References: <cover.1400271129.git.rgb@redhat.com>	<1400593754.15733.4.camel@flatline.rdu.redhat.com>	<20140520140146.GA8079@madcap2.tricolour.ca>	<20140819164617.GE9003@madcap2.tricolour.ca>	<8738crst5i.fsf@x220.int.ebiederm.org> <20140820162511.GS4462@madcap2.tricolour.ca>
In-Reply-To: <20140820162511.GS4462@madcap2.tricolour.ca>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 20/08/2014 18:25, Richard Guy Briggs a écrit :
> On 14/08/19, Eric W. Biederman wrote:
>> Richard Guy Briggs <rgb@redhat.com> writes:
>>
>>> On 14/05/20, Richard Guy Briggs wrote:
>>>> On 14/05/20, Eric Paris wrote:
>>>>> On Tue, 2014-05-20 at 09:12 -0400, Richard Guy Briggs wrote:
>>>>>> The purpose is to track namespaces in use by logged processes from the
>>>>>> perspective of init_*_ns.
>>>
>>> (Including the Linux API list due to the additions to /proc/<pid>/ns/.
>>> Please see http://www.kernelhub.org/?p=2&msg=477668 and in particular
>>> http://www.kernelhub.org/?msg=477678&p=2 )
>>
>> Sigh if you have to use something like this use the proc inode
>> number.  It is the same thing.
>>
>> I hate to claim it is unique absent of the proc superblock but it is and
>> will be for the forseable future.
>>
>> It would be better to include the block device number that appears in
>> proc of 3h of the primary mount of to qualify the number.  But it is not
>> particularly important.  Coming up with an additional unique number that
>> needs to be maintained seems stronlgy silly.
>
> I am reading a contradiction here:
> 	https://www.redhat.com/archives/linux-audit/2013-March/msg00032.html
>
> and this posting went completely ignored:
> 	https://www.redhat.com/archives/linux-audit/2014-January/msg00180.html
>
> And then there was this patchset and thread where there was some good
> discussion to clarify the use case:
> 	https://lkml.org/lkml/2014/4/22/662
>
> Then V2:
> 	https://lkml.org/lkml/2014/5/9/637
>
> Then V3 3 months ago:
> 	https://www.redhat.com/archives/linux-audit/2014-May/msg00071.html
>
> I'm about to post another version of the patchset addressing Eric Paris'
> concerns about record types, field naming...
I also try to find a solution to identify netns in userland to solve
some network problems (see 
http://thread.gmane.org/gmane.linux.network/315933/focus=321753).

This serial number solution may be reused for this.
We really need to find a way to solve this.


Regards,
Nicolas
