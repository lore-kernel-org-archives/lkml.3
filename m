Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab3FQXtb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:49:31 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:56912 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3FQXt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:49:29 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <51B9B0F8.3070301@redhat.com>
References: <20130613081551.11870.77028.stgit@maximpc.sw.ru>
	<51B9B0F8.3070301@redhat.com>
Date: Tue, 18 Jun 2013 01:49:27 +0200
Message-ID: <CAJfpegu7NE9_yZhSmHXVJ=wZTY=xPER8CVsxT3qNSncjOFGVsw@mail.gmail.com>
Subject: Re: [PATCH] fuse: hold i_mutex in fuse_file_fallocate() - v2
From: Miklos Szeredi <miklos@szeredi.hu>
To: Brian Foster <bfoster@redhat.com>
Cc: Maxim Patlasov <MPatlasov@parallels.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Anand Avati <avati@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 1:46 PM, Brian Foster <bfoster@redhat.com> wrote:
> On 06/13/2013 04:16 AM, Maxim Patlasov wrote:
>> Changing size of a file on server and local update (fuse_write_update_size)
>> should be always protected by inode->i_mutex. Otherwise a race like this is
>> possible:
>>
>> 1. Process 'A' calls fallocate(2) to extend file (~FALLOC_FL_KEEP_SIZE).
>> fuse_file_fallocate() sends FUSE_FALLOCATE request to the server.
>> 2. Process 'B' calls ftruncate(2) shrinking the file. fuse_do_setattr()
>> sends shrinking FUSE_SETATTR request to the server and updates local i_size
>> by i_size_write(inode, outarg.attr.size).
>> 3. Process 'A' resumes execution of fuse_file_fallocate() and calls
>> fuse_write_update_size(inode, offset + length). But 'offset + length' was
>> obsoleted by ftruncate from previous step.
>>
>> Changed in v2 (thanks Brian and Anand for suggestions):
>>  - made relation between mutex_lock() and fuse_set_nowrite(inode) more
>>    explicit and clear.
>>  - updated patch description to use ftruncate(2) in example
>>
>> Signed-off-by: Maxim V. Patlasov <MPatlasov@parallels.com>

Thanks, applied.

Miklos
