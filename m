Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbaFIHuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 03:50:16 -0400
Received: from relay.parallels.com ([195.214.232.42]:40457 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903AbaFIHuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 03:50:12 -0400
Message-ID: <53956730.1070302@parallels.com>
Date: Mon, 9 Jun 2014 11:50:08 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: John Muir <john@jmuir.com>
CC: <miklos@szeredi.hu>, fuse-devel <fuse-devel@lists.sourceforge.net>,
        Linux List <linux-kernel@vger.kernel.org>
Subject: Re: [fuse-devel] [PATCH 0/5] fuse: close file synchronously (v2)
References: <20140606132541.30321.68679.stgit@localhost.localdomain> <E5474E5C-B6FC-459C-ACCE-F6871221D45E@jmuir.com>
In-Reply-To: <E5474E5C-B6FC-459C-ACCE-F6871221D45E@jmuir.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.24.252]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 05:51 PM, John Muir wrote:
> On 2014.06.06, at 15:27 , Maxim Patlasov <mpatlasov@parallels.com> wrote:
>
>> The patch-set resolves the problem by making fuse_release synchronous:
>> wait for ACK from userspace for FUSE_RELEASE if the feature is ON.
> Why not make this feature per-file with a new flag bit in struct fuse_file_info rather than as a file-system global?

I don't expect a great demand for such a granularity. File-system global 
"close_wait" conveys a general user expectation about filesystem 
behaviour in distributed environment: if you stopped using a file on 
given node, whether it means that the file is immediately accessible 
from another node.

Maxim

>
> John.
>
> --
> John Muir - john@jmuir.com
> +32 491 64 22 76
>
>
>

