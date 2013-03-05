Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3CETcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 14:32:03 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:48716 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab3CETcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 14:32:00 -0500
MIME-Version: 1.0
In-Reply-To: <CAPXgP11AB7=2oeXtxb0so4a8hms7-_UWJDVE=6kndU062tGycQ@mail.gmail.com>
References: <CAGXu5jK7x+gFKgCN5=ZF+kSc4xSNbGtSERHCoOnCEgiJ1_wNGg@mail.gmail.com>
	<20130303005700.GA32213@austin.hallyn.com>
	<874ngtxgt5.fsf@xmission.com>
	<CAGXu5j+bwUx6r++ttvYg4yJrUUHxoQ86tQ0JzEBoQQU6KAh9ww@mail.gmail.com>
	<874ngsrvrh.fsf@xmission.com>
	<CAGXu5jJiO=BmjVbpVJhxHbafn5T_SQbe5g-RLxRbmknNnQMyfQ@mail.gmail.com>
	<87k3pnmwpk.fsf_-_@xmission.com>
	<878v63mwm3.fsf_-_@xmission.com>
	<CAPXgP11AB7=2oeXtxb0so4a8hms7-_UWJDVE=6kndU062tGycQ@mail.gmail.com>
Date: Tue, 5 Mar 2013 11:32:00 -0800
Message-ID: <CAGXu5j+ygnVMynwKHBzfaPT=vx4vCka5RcBpyX+BHvSMokV8ow@mail.gmail.com>
Subject: Re: [PATCH 2/2] fs: Limit sys_mount to only request filesystem modules.
From: Kees Cook <keescook@google.com>
To: Kay Sievers <kay@vrfy.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Brad Spengler <spender@grsecurity.net>,
        Al Viro <viro@zeniv.linux.org.uk>, PaX Team <pageexec@freemail.hu>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 11:06 AM, Kay Sievers <kay@vrfy.org> wrote:
> On Mon, Mar 4, 2013 at 8:51 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> Modify the request_module to prefix the file system type with "fs-"
>> and add aliases to all of the filesystems that can be built as modules
>> to match.
>>
>> A common practice is to build all of the kernel code and leave code
>> that is not commonly needed as modules, with the result that many
>> users are exposed to any bug anywhere in the kernel.
>>
>> Looking for filesystems with a fs- prefix limits the pool of possible
>> modules that can be loaded by mount to just filesystems trivially
>> making things safer with no real cost.
>
> '-' is a commonly used part of a module name, and does not mix well
> with ramdom user provided names.
>
> We usually use ':' as the prefix separator for modaliases, when
> user-supplied strings are prefixed with the subsystem.
>
> I think it would be nicer to change that, and I'm sure some creative
> guy calls the next filesystem of the month fs-$something :)

The precedent is "-". "netdev-" "pf-net-" etc. Naming something
fs-$something is fine as long as it's actually a filesystem. :)

-Kees

-- 
Kees Cook
Chrome OS Security
