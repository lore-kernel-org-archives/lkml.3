Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934104Ab3GPVd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 17:33:28 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:45300 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934080Ab3GPVdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 17:33:05 -0400
Message-ID: <51E5BC0D.3090303@mit.edu>
Date: Tue, 16 Jul 2013 14:33:01 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] allow some kernel filesystems to be mounted in a
 user namespace
References: <20130716192920.GA8980@sergelap> <20130716193826.GP4165@ZenIV.linux.org.uk> <20130716195002.GA23370@mail.hallyn.com>
In-Reply-To: <20130716195002.GA23370@mail.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 12:50 PM, Serge E. Hallyn wrote:
> Quoting Al Viro (viro@ZenIV.linux.org.uk):
>> On Tue, Jul 16, 2013 at 02:29:20PM -0500, Serge Hallyn wrote:
>>> All the files will be owned by host root, so there's no security
>>> concern in allowing this.
>>
>> Files owned by root != very bad things can't be done by non-root.
>> Especially for debugfs, which is very much a "don't even think about
>> mounting that on a production box" thing...
> 
> I would prefer it not be mounted.  But near as I can tell there
> should be no regression security-wise whether an unprivileged
> user on the host has access to it, or whether a user in a
> non-init user ns is allowed to mount it.  (Obviously I could very
> well be wrong)

I would argue that either (a) debugfs denies everything to non-root, so
mounting it in a (rootless) userns is useless or (b) it doesn't, in
which case it's dangerous.

In neither case does it make sense to me to allow the mount.

--Andy
