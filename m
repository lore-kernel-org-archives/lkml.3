Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab3FEJwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:52:20 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:57343 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3FEJwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:52:19 -0400
Message-ID: <51AF0A4A.9020106@linux.vnet.ibm.com>
Date: Wed, 05 Jun 2013 15:22:10 +0530
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: jkenisto@linux.vnet.ibm.com, tony.luck@intel.com, keescook@chromium.org,
        mahesh@linux.vnet.ibm.com, ccross@android.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        paulus@samba.org, anton@samba.org, cbouatmailru@gmail.com
Subject: Re: [PATCH v3 0/8] Nvram-to-pstore
References: <20130425100952.21017.51799.stgit@aruna-ThinkPad-T420> <1370064348.3766.37.camel@pasglop> <51AEFE28.3040104@linux.vnet.ibm.com> <1370425396.3766.219.camel@pasglop>
In-Reply-To: <1370425396.3766.219.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060509-5564-0000-0000-0000083A6D69
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 June 2013 03:13 PM, Benjamin Herrenschmidt wrote:
> On Wed, 2013-06-05 at 14:30 +0530, Aruna Balakrishnaiah wrote:
>> Hi Ben,
>>
>> On Saturday 01 June 2013 10:55 AM, Benjamin Herrenschmidt wrote:
>>> Another question...
>>>
>>> Should the core pstore fail to unlink partitions that don't have
>>> an ->erase callback ? IE. Why would you let anyone erase the OFW
>>> common partition for example ? That means that userspace tools
>>> can no longer manipulate it but we certainly don't want to remove
>>> it from the nvram itself.
>> Since I do not have a callback for erase in nvram, pstore
>> simply unlinks the file and will not delete the partition.
> Right. My point is that it should probably refuse to unlink the file
> too. What's the point in letting the user remove the file, potentially
> making tools not working anymore, without any way to bring it back other
> than a reboot ?
>
> unlink makes sense if it also removes the partition. If it doesn't it
> should just fail.

Right, makes sense. Will create a patch to fix it in pstore.

>>> That leads to a deeper concern. Looking at how efi-pstore works,
>>> it looks like they create a file for each var.
>>>
>>> This looks like something valuable we could do for something like
>>> the common partition since typically it's made of name,value pairs.
>>>
>>> However, pstore is a flat space, while we have patitions which
>>> themselves can be organized in name,value pairs (some at least)
>>>
>>> I wonder if it's time to introduce pstore directories... Or do
>>> we stick to our special tools to interpret/change the name,value
>>> pairs ?
>> Since pstore infrastructure creates the file in read-only mode
>> creating files for name, value pairs will not be useful to us.
>> So for now, we need to stick to our tools to interpret/change
>> the name,value pairs.
>>
>> And also, pstore filenames are controlled by pstore infrastructure
>> so that would need quite some changes in the pstore infrastructure.
>>
>> I think for now it would be better to dump the contents of common
>> partition as it is.
> Ok.
>
>>> Also do we want to add an ability to resize partitions ? Possibly
>>> based on how much is written to them ?
>> Yes it will be good to that.
>>
>> If your fine with patchset apart from the filenames of-config and common
>> partitions. I will post the next version of it with powerpc prefix.
> Yes, I'm ok with it.
>
> Cheers,
> Ben.
>
>>> Cheers,
>>> Ben.
>>>
>>>
>>> _______________________________________________
>>> Linuxppc-dev mailing list
>>> Linuxppc-dev@lists.ozlabs.org
>>> https://lists.ozlabs.org/listinfo/linuxppc-dev
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
>

