Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936630AbaFIJgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:36:08 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:55690 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933376AbaFIJ0s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:26:48 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [fuse-devel] [PATCH 0/5] fuse: close file synchronously (v2)
From: John Muir <john@jmuir.com>
In-Reply-To: <53956730.1070302@parallels.com>
Date: Mon, 9 Jun 2014 11:26:46 +0200
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Linux List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <C6F7C8BC-7F62-45D9-AE9D-52CF096ACBC2@jmuir.com>
References: <20140606132541.30321.68679.stgit@localhost.localdomain> <E5474E5C-B6FC-459C-ACCE-F6871221D45E@jmuir.com> <53956730.1070302@parallels.com>
To: Maxim Patlasov <mpatlasov@parallels.com>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.06.09, at 9:50 , Maxim Patlasov <mpatlasov@parallels.com> wrote:

> On 06/06/2014 05:51 PM, John Muir wrote:
>> On 2014.06.06, at 15:27 , Maxim Patlasov <mpatlasov@parallels.com> wrote:
>> 
>>> The patch-set resolves the problem by making fuse_release synchronous:
>>> wait for ACK from userspace for FUSE_RELEASE if the feature is ON.
>> Why not make this feature per-file with a new flag bit in struct fuse_file_info rather than as a file-system global?
> 
> I don't expect a great demand for such a granularity. File-system global "close_wait" conveys a general user expectation about filesystem behaviour in distributed environment: if you stopped using a file on given node, whether it means that the file is immediately accessible from another node.
> 

By user do you mean the end-user, or the implementor of the file-system? It seems to me that the end-user doesn't care, and just wants the file-system to work as expected. I don't think we're really talking about the end-user.

The implementor of a file-system, on the other hand, might want the semantics for close_wait on some files, but not on others. Won't there be a performance impact? Some distributed file-systems might want this on specific files only. Implementing it as a flag on the struct fuse_file_info gives the flexibility to the file-system implementor.

Regards,

John.

--
John Muir - john@jmuir.com
+32 491 64 22 76