Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaJ1NDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:03:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46169 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbaJ1NDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:03:10 -0400
Message-ID: <544F940B.8090707@suse.com>
Date: Tue, 28 Oct 2014 14:03:07 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Andrew Cooper <andrew.cooper3@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
CC: boris.ostrovsky@oracle.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 0/2] xen: Switch to virtual mapped linear
 p2m list
References: <1414421551-31555-1-git-send-email-jgross@suse.com>	<544E61DD.8050305@citrix.com>	<544F22E4.9040706@suse.com> <1414489898.23883.25.camel@citrix.com> <544F83C1.3010402@citrix.com> <544F8713.9040803@suse.com> <544F8E89.6070006@citrix.com> <544F8F3A.3030505@citrix.com> <544F8FBB.2010709@citrix.com> <544F902C.8040502@citrix.com>
In-Reply-To: <544F902C.8040502@citrix.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2014 01:46 PM, Andrew Cooper wrote:
> On 28/10/14 12:44, David Vrabel wrote:
>> On 28/10/14 12:42, Andrew Cooper wrote:
>>> On 28/10/14 12:39, David Vrabel wrote:
>>>> On 28/10/14 12:07, Juergen Gross wrote:
>>>>> Okay, back to the original question: is the (up to) 64 MB virtual
>>>>> mapping of the p2m list on 32-bit pv domains a problem or not?
>>>> I think up-to 64 MiB of vmalloc area is fine.  The vmalloc space can be
>>>> increased with a command line option in the unlikely event that there
>>>> are domUs that would be affected.
>>>>
>>>>> If yes, the virtual mapped linear p2m list could still be used on
>>>>> 64 bit domains, paving the way for support of more than 512 GB of
>>>>> domain memory. OTOH having to keep the p2m tree coding alive isn't
>>>>> my favorite solution...
>>>> Having to keep both the tree and linear p2m code would be awful.  Let's
>>>> not do this!
>>>>
>>>> David
>>> How is the toolstack expected to find and mutate this p2m on migrate?
>>> The toolstack does not use guest pagetables.
>> The p2m code maintains two trees.  One for use by the guest and one for
>> use by the toolstack.  This series replaces the first tree with the
>> linear array (at least that's how I understand it -- I've not reviewed
>> the series in detail yet).
>
> Ah - fine (if that is how it works).

That's the plan, yes.


Juergen

