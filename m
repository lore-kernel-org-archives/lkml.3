Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbaAJRNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 12:13:43 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:59563 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbaAJRNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 12:13:38 -0500
MIME-Version: 1.0
In-Reply-To: <52D01D82.5070202@canonical.com>
References: <1386546869-31900-1-git-send-email-yinghai@kernel.org>
	<1386546869-31900-3-git-send-email-yinghai@kernel.org>
	<CAErSpo6VvV21DyHuHLcsA+_KPQcYdAWXtaVbZGUA-M9+iji0fw@mail.gmail.com>
	<CAE9FiQUWFoyg_7TPaBVftpojCocNu0=1yWtqKTBvkQkRhNOnhg@mail.gmail.com>
	<CAErSpo5+jY-P-9iUj0RVqyZzXwQcq9m9PqWKzZDU0yjK=4gAeQ@mail.gmail.com>
	<CAE9FiQXf6w0u+JLu-JHd45ofSTShaB0MoMNbck9EE-y3u6B98w@mail.gmail.com>
	<52A8BAC5.70006@canonical.com>
	<CAE9FiQV8mfF6SMTbZN5H+DmyuM0663wQyoKYJDa7MiBR4i7XQg@mail.gmail.com>
	<52D01D82.5070202@canonical.com>
Date: Fri, 10 Jan 2014 09:13:37 -0800
X-Google-Sender-Auth: xQiTIErrzaVMt6O6s9d5jgPeLcM
Message-ID: <CAE9FiQUD0XvPJNFNMoqX6J67TKuGcj+pSbj+iPUf=fvC-4UXOQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] PCI: Only enable realloc auto when root bus has 64bit mmio
From: Yinghai Lu <yinghai@kernel.org>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 8:19 AM, Joseph Salisbury
<joseph.salisbury@canonical.com> wrote:
> On 12/11/2013 02:55 PM, Yinghai Lu wrote:
>> On Wed, Dec 11, 2013 at 11:19 AM, Joseph Salisbury
>> <joseph.salisbury@canonical.com> wrote:
>>> On 12/09/2013 03:10 PM, Yinghai Lu wrote:
>>>> On Mon, Dec 9, 2013 at 11:42 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>>>> That doesn't answer my question at all.
>>>>>
>>>>> I understand that this change makes it so Joseph doesn't have to use
>>>>> "pci=realloc=off".  But why should auto-reallocation be limited to
>>>>> buses that have resources above 4GB?  That doesn't make any sense.
>>>>>
>>>>> We should fix the reallocation code so it can deal with this case.  If
>>>>> there's not enough space for everything, obviously we have to leave
>>>>> something unassigned.  A ROM BAR is a good candidate for leaving
>>>>> unassigned, because most of the time we can get along without it.
>>>> Yes, that is ideal and not that simple.
>>>> but that would be hard to backport to old kernels.
>>>>
>>>> BTW, Joseph, can you try
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
>>>> for-pci-3.14
>>>> with pci=realloc=on
>>>>
>>>> on that system?
>>>>
>>>> Thanks
>>>>
>>>> Yinghai
>>> I noticed there was some back and forth on this thread.  Do you still
>>> want me to test this version, Yinghai?
>> Yes, if that works, we would not need to put the patch in upstream for limiting
>> realloc auto scope.
>>
>
> Another user has confirmed that at test kernel from your branch[0] does
> resolve the bug.

Hi, Joe,

Bjorn does not want to limit auto realloc, so this patch can not make
to upstream at this point.

so we may have to ask user to append "pci=realloc=off" before we find
more smart way to realloc
resource.

Thanks

Yinghai
