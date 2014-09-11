Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbaIKE3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 00:29:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53877 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbaIKE3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 00:29:36 -0400
Message-ID: <5411252A.1030901@suse.com>
Date: Thu, 11 Sep 2014 00:29:30 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, Matt <jackdachef@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: Re: linux-3.16.2 queue (3.16.1+)
References: <CAG-aW06Q9VVyW-atZEsURs0rfjysdEbxb_dC4Tm3K-tZg++tQg@mail.gmail.com> <20140828152205.GA18432@kroah.com> <CAG-aW05qkQKgntBM87XHSMECjD-GMjeRt+m0-0CkezBG_weCOg@mail.gmail.com> <20140828153252.GA18868@kroah.com> <CAG-aW07Lx=WOEf+j=_+G5T57uzhvKiP3-ZpaadKvoafW=iJKrw@mail.gmail.com> <CAG-aW04YvZVxKBhSAYqhr5OBFovA3HHHWgdfEQU_jXKzQK7QdA@mail.gmail.com> <20140907031814.GA961@kroah.com>
In-Reply-To: <20140907031814.GA961@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 9/6/14, 11:18 PM, Greg KH wrote:
> On Sun, Sep 07, 2014 at 02:47:55AM +0200, Matt wrote:
>> On Thu, Aug 28, 2014 at 9:18 PM, Matt <jackdachef@gmail.com>
>> wrote:
>>> On Thu, Aug 28, 2014 at 5:32 PM, Greg KH
>>> <gregkh@linuxfoundation.org> wrote:
>>>> On Thu, Aug 28, 2014 at 05:27:27PM +0200, Matt wrote:
>>>>> On Thu, Aug 28, 2014 at 5:22 PM, Greg KH
>>>>> <gregkh@linuxfoundation.org> wrote:
>>>>>> On Thu, Aug 28, 2014 at 05:16:58PM +0200, Matt wrote:
>>>>>>> Hi Greg,
>>>>>>> 
>>>>>>> 
>>>>>>> please consider adding the following 2 patches to
>>>>>>> 3.16.2:
>>>>>>> 
>>>>>>> Jan Kara (1): reiserfs: Fix use after free in journal
>>>>>>> teardown
>>>>>>> 
>>>>>>> Jeff Mahoney (1): reiserfs: fix corruption introduced
>>>>>>> by balance_leaf refactor
>>>>>>> 
>>>>>>> 
>>>>>>> 
>>>>>>> Reason/Related:
>>>>>>> 
>>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=83121
>>>>>>> 
>>>>>>> https://bugzilla.kernel.org/show_bug.cgi?id=83321
>>>>>>> 
>>>>>>> http://forums.gentoo.org/viewtopic-t-998538-postdays-0-postorder-asc-start-0.html
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> 
Many thanks in advance
>>>>>> 
>>>>>> I need git commit ids of these patches in Linus's tree,
>>>>>> can you provide those please?
>>>>>> 
>>>>>> thanks,
>>>>>> 
>>>>>> greg k-h
>>>>> 
>>>>> 
>>>>> Sure:
>>>>> 
>>>>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=27d0e5bc85f3341b9ba66f0c23627cf9d7538c9d
>>>>>
>>>>> 
reiserfs: fix corruption introduced by balance_leaf refactor
>>>>> 
>>>>> 
>>>>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=01777836c87081e4f68c4a43c9abe6114805f91e
>>>>>
>>>>> 
reiserfs: Fix use after free in journal teardown
>>>>> 
>>>>> 
>>>>> 
>>>>> are checkpatch warnings usually also fixed within stable
>>>>> releases ?
>>>> 
>>>> No, not at all, please read
>>>> Documentation/stable_kernel_patches.txt for what is
>>>> acceptable for stable kernel patches.
>>>> 
>>>> thanks,
>>>> 
>>>> greg k-h
>>> 
>>> 
>>> okay, will do
>>> 
>>> thanks for pointing that out
>>> 
>>> 
>>> Regards
>>> 
>>> Matt
>> 
>> Hi Greg,
>> 
>> could you please add the above mentioned two patches
>> 
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=27d0e5bc85f3341b9ba66f0c23627cf9d7538c9d
>>
>> 
reiserfs: fix corruption introduced by balance_leaf refactor
>> 
>> 
>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=01777836c87081e4f68c4a43c9abe6114805f91e
>>
>> 
reiserfs: Fix use after free in journal teardown
>> 
>> in next stable (3.16.3) kernel ?
>> 
>> more and more people seem to be affected by the data corruption 
>> introduced by the recent changes.
>> 
>> 
>> Reading through Documentation/stable_kernel_rules.txt, 
>> http://cwe.mitre.org/data/definitions/416.html and 
>> http://www.hpenterprisesecurity.com/vulncat/en/vulncat/cpp/use_after_free.html
>>
>>
>> 
both patches seem relevant enough (concerning data integrity
>> filesystem-wise and security) to be included for the stable
>> branch
> 
> I'll queue this up when I get a chance, there are over 300 patches 
> pending for the stable kernels right now :(
> 
> Also, in the future, always cc stable@vger.kernel.org for any
> stable requests so that they don't get lost.

Hi Greg -

27d0e5bc85f3341b9ba66f0c23627cf9d7538c9d
Author: Jeff Mahoney <jeffm@suse.com>
Date:   Mon Aug 4 19:51:47 2014 -0400

    reiserfs: fix corruption introduced by balance_leaf refactor

    Commits f1f007c308e (reiserfs: balance_leaf refactor, pull out
    balance_leaf_insert_left) and cf22df182bf (reiserfs: balance_leaf
    refactor, pull out balance_leaf_paste_left) missed that the `body'
    pointer was getting repositioned. Subsequent users of the pointer
    would expect it to be repositioned, and as a result, parts of the
    tree would get overwritten. The most common observed corruption
    is indirect block pointers being overwritten.

    Since the body value isn't actually used anymore in the called
routines,
    we can pass back the offset it should be shifted. We constify the body
    and ih pointers in the balance_leaf as a mostly-free preventative
measure.

    Cc: <stable@vger.kernel.org> # 3.16
    Reported-and-tested-by: Jeff Chua <jeff.chua.linux@gmail.com>
    Signed-off-by: Jeff Mahoney <jeffm@suse.com>
    Signed-off-by: Jan Kara <jack@suse.cz>

Should there have been more? I thought it was enough to add the Cc
tag. This one has been in the tree, with the tags and with
"corruption" in the Subject since 13 Aug. I know you're busy but this
seems like a pretty obvious candidate for stable inclusion.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)

iQIcBAEBAgAGBQJUESUpAAoJEB57S2MheeWyt9oQAIEnvZPojErvzzv4IcvVheSI
Ju1XChkU4YDRW3W2e8PEjAhiPd1dMP7aEJvfq6AxlKYAYENaS/S2LdSbBbeVctFa
1VwBVakDkmHduVcb2hl3ldIQlHRW0w/q/fSk+NKZavANS/maIK/mj2HE8S3Op17C
iGsGZiluqaYp56yPHJK7XDorpWFoCVXIPlHUbec8lIxnyPqeytHo2W5UtfZZVeN3
BfGICzR57i7YjOtQ/lsmusiUjp7Ym4REKX1GGnIcZ1Po5F8oX4phMVaUR0gR1NSA
eYBcTyH245iWTQBFqE9D5AR0pHLnmi6EySEbNIWU3w0OYffDCBpqU7A7Dm5O2kng
caIlNuf4TMEp7QzVC8hxCL61nxBWJ6L2RQ9NkOg9zLHXdaWhJSjHl7TdRUPV/C3V
RzNCZEWvqEpMoju145Wez7JlcE/GlsBclNFGBqypEWN364B/MprKe5vhpeXJ+1H2
yUq/qKlgQLZe5uPCwMdcyAB3xTX8mIzG4nz8RWez6WPjhAlb82xtBSl0btWjSnVM
4YlWy/5jCWgyjXzrM3hd8P3SJi+l69rVUE+UcMvOqHq3oCFBddhlUh9tHM7pn9tH
sXTo8f8s9Pe7+HvbA0bwtwbwTQ8tNxn87ovuVnAO86RLmeeM7HCfqBU/4lKEZ0WE
TG7eSSLjQVBxo+kQCZOo
=OOOa
-----END PGP SIGNATURE-----
