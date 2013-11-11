Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab3KKWpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 17:45:46 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:64507 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab3KKWph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 17:45:37 -0500
MIME-Version: 1.0
In-Reply-To: <528156E4.1030409@intel.com>
References: <1383745544-391-1-git-send-email-zwu.kernel@gmail.com>
	<1383745544-391-8-git-send-email-zwu.kernel@gmail.com>
	<528156E4.1030409@intel.com>
Date: Tue, 12 Nov 2013 06:45:37 +0800
Message-ID: <CAEH94LjoY6L6zDwTh3XKim17VgRTkdqBKpm7TgX0HGok==p+kg@mail.gmail.com>
Subject: Re: [PATCH v6 07/11] VFS hot tracking: Add a /proc interface to
 control memory usage
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        Chandra Seetharaman <sekharan@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 6:15 AM, Dave Hansen <dave.hansen@intel.com> wrote:
> On 11/06/2013 05:45 AM, Zhi Yong Wu wrote:
>> Introduce a /proc interface hot-mem-high-thresh and
>> to cap the memory which is consumed by hot_inode_item
>> and hot_range_item, and they will be in the unit of
>> 1M bytes.
>
> You don't seem to have any documentation for this, btw... :(
>
>> +             .procname       = "hot-mem-high-thresh",
>
> *Always* put units on these.  I know you mention it in a code comment,
> but please also include it in the proc filename too.
If you think it is better, i will add it.
>
> In general, why do you have to control the number of these statically?
It gives the user or admin one optional chance to control the amount
of memory consumed by VFS hot tracking. And you can choose not to use
it.
> Shouldn't you just define a shrinker and let memory pressure determine
> how many of these we allow to exist?
How about if the user and admin hope to control the amount of the
memory consumed by VFS hot tracking? e.g. If the host has several
hundred of G or T memory, but the user or admin hope that the memory
size consumed by VFS hot tracking is under several G, In the case,
maybe a shrinker of VFS hot tracking will never be invoked by system
memory module, so this interface will make sense.



-- 
Regards,

Zhi Yong Wu
