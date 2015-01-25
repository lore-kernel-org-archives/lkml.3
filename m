Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbbAYWU6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 17:20:58 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbbAYWUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 17:20:55 -0500
Message-ID: <54C56C45.6060802@nod.at>
Date: Sun, 25 Jan 2015 23:20:53 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: Detect API misuse of i_op->lookup
References: <1422223060-8561-1-git-send-email-richard@nod.at> <20150125221643.GK29656@ZenIV.linux.org.uk>
In-Reply-To: <20150125221643.GK29656@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 25.01.2015 um 23:16 schrieb Al Viro:
> On Sun, Jan 25, 2015 at 10:57:40PM +0100, Richard Weinberger wrote:
>> Hunting down a refcount issue in an out-of-tree filesystem uncovered
>> that its lookup function directly returned the dentry which was passed to it.
>> Add a BUG_ON() to detect such misuse in future.
> 
> In principle, it's not a bug.  You *must* grab a reference to dentry before
> returning it, but you can very well decide to return the one you've got -
> any place where have ->lookup() return NULL has every right to become
> return dget(dentry).

Thanks for the clarification! The filesystem in question did of course
not grab a reference before returning the same dentry.

Thanks,
//richard
