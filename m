Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab3GBGL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 02:11:58 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40812 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218Ab3GBGLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 02:11:55 -0400
Message-ID: <51D26F16.4040803@gmail.com>
Date: Tue, 02 Jul 2013 02:11:34 -0400
From: Dong Fang <yp.fangdong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: remove the unnecessrary code of fs/inode.c
References: <1372681143-23465-1-git-send-email-yp.fangdong@gmail.com> <20130702044122.GJ4165@ZenIV.linux.org.uk>
In-Reply-To: <20130702044122.GJ4165@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2013 12:41 AM, Al Viro wrote:
> On Mon, Jul 01, 2013 at 08:19:03AM -0400, Dong Fang wrote:
>> These functions, such as find_inode_fast() and find_inode(), iget_lock() and
>> iget5_lock(), insert_inode_locked() and insert_inode_locked4(), almost have
>> the same code.
>
> NAK.  These functions exist exactly because the variant with callbacks
> costs more.  We walk the hash chain and for each inode on it your
> variant would result in
> 	* call
> 	* fetching ino from memory
> 	* comparison (and storing result in general-purpose register)
> 	* return
> 	* checking that register and branch on the result of that check
> What's more, the whole thing's not fun for branch predictor.
>
> It is a hot enough path to warrant a special-cased variant; if we can't
> get away with that, we use the variants with callbacks, but on filesystems
> where ->i_ino is sufficient as search key we really want to avoid the
> overhead.
>

that's right, i didn't think of it, but i think may be we can remove
the deduplicate codes of iget_lock() and iget5_lock() function, right?

if ok, i will send a new patch later. :)

thx Viro.
