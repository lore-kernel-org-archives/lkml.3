Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbaIZB6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 21:58:42 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:62445 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbaIZB6k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 21:58:40 -0400
MIME-Version: 1.0
In-Reply-To: <5423D808.7050800@6wind.com>
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>
	<CAHA+R7NnBJ=T3sukzzp-OD2am1nd318XbrXCX84LfSL=nu9ojw@mail.gmail.com>
	<54228D87.3070309@6wind.com>
	<CAHA+R7NfJYzCsZx0E9YVXKVCQbCm_thPSi+80tix8Z9nVA82Ug@mail.gmail.com>
	<CAHA+R7MVL=WpepRy8iz6iT6Kkq1RHG+b9TxJothP94ixyAj-3Q@mail.gmail.com>
	<5422F1F7.8010308@6wind.com>
	<CAHA+R7MM04ew=J8sHfSQERwoCAgEDfrGgtgRORqs3ePgtjVYWg@mail.gmail.com>
	<5423D808.7050800@6wind.com>
Date: Thu, 25 Sep 2014 18:58:39 -0700
Message-ID: <CAHA+R7OdOUMShX6Nphdfh8+fGiXyO+sGNHy0ch_XYh5dpURcmQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v2 0/5] netns: allow to identify peer netns
From: Cong Wang <cwang@twopensource.com>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: netdev <netdev@vger.kernel.org>, containers@lists.linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org, David Miller <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 1:53 AM, Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
> Le 24/09/2014 18:48, Cong Wang a écrit :
>
>> On Wed, Sep 24, 2014 at 9:31 AM, Nicolas Dichtel
>> <nicolas.dichtel@6wind.com> wrote:
>>>>
>>>> I think in this case your ID's are still available, but aren't you
>>>> providing a new way
>>>> for the inner netns device to escape which we are trying to avoid?
>>>
>>>
>>> It's why the ids depend on user ns. Only if user ns are the same we allow
>>> to
>>> get an id for a peer netns.
>>
>>
>> Too late, userns is relatively new, relying on it breaks our existing
>> assumption.
>>
> I don't get your point. netns has been added in kernel after user ns:
> acce292c82d4 user namespace: add the framework => 2.6.23
> 5f256becd868 [NET]: Basic network namespace infrastructure. => 2.6.24

Was it complete on 2.6.x? I doubt...

https://lkml.org/lkml/2014/8/20/826

   As at Linux 3.8, most relevant subsystems supported  user  names‐
       paces,  but  a number of filesystems did not have the infrastruc‐
       ture needed to map user and group IDs  between  user  namespaces.
       Linux  3.9  added the required infrastructure support for many of
       the remaining unsupported filesystems (Plan 9 (9P),  Andrew  File
       System  (AFS),  Ceph,  CIFS,  CODA,  NFS, and OCFS2).  Linux 3.11
       added support the last of the unsupported major filesystems, XFS.


>
> In the kernel, each netns is linked with a user ns.

Are you saying every time we create a netns we have a new userns?
This doesn't make sense for me.
