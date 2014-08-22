Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbaHVALt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 20:11:49 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:51844 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630AbaHVALr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 20:11:47 -0400
MIME-Version: 1.0
In-Reply-To: <A54DB26A-07AF-4DA8-899F-1DCE527C2389@holtmann.org>
References: <606D4327-C729-49F7-9CFD-3D25D0A62A13@holtmann.org>
 <53F67057.4030202@amacapital.net> <A54DB26A-07AF-4DA8-899F-1DCE527C2389@holtmann.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 21 Aug 2014 17:11:26 -0700
Message-ID: <CALCETrWfHbT_3F7uStXSsKkjBN2xTMc5Wj6gviFNTgFSuPjKjQ@mail.gmail.com>
Subject: Re: Issue with clone() and CLONE_NEWUSER as unprivileged user
To: Marcel Holtmann <marcel@holtmann.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 3:26 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Andy,
>
>>> I am trying to use clone() and CLONE_NEWUSER for creating a new user namespace as an unprivileged user. I always get an operation not permitted error. However when I used fork() + unshare() as unprivileged user, I can create the new user namespace just fine.
>>>
>>> Is there something obvious that I am missing? My understand is that CLONE_NEWUSER should not require any special capabilities. I tried the sample code from the manpage and also from LWN.net, but both give me the same error.
>>
>> It works for me on 3.16 and 3.15 but not on 3.15.8-200.fc20.x86_64.  I'm
>> a bit confused.  What kernel are you using?
>
> I am running 3.15.6-200.fc20.x86_64 actually. What confused me is that fork() + unshare() works fine, but clone() doesn't.

Ok, tracked it down.  This is a Fedora-specific issue.

https://bugzilla.redhat.com/show_bug.cgi?id=917708

--Andy
