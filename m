Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbaHHCro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 22:47:44 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:37253 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbaHHCrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 22:47:43 -0400
MIME-Version: 1.0
Date: Thu, 7 Aug 2014 22:47:42 -0400
Message-ID: <CAFdhcLRbffwYhwtP9J9VzB7LPE1kbmb9GTB2rpAb3k4gC5vOgg@mail.gmail.com>
Subject: Re: [RFC 2/3] zsmalloc/zram: add zs_get_max_size_bytes and use it in zram
From: David Horner <ds2horner@gmail.com>
To: minchan@kernel.org
Cc: linux-kernel-mm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 [2/3]


 But why isn't mem_used_max writable? (save tearing down and rebuilding
 device to reset max)

 static DEVICE_ATTR(mem_used_max, S_IRUGO, mem_used_max_show, NULL);

 static DEVICE_ATTR(mem_used_max, S_IRUGO | S_IWUSR, mem_used_max_show, NULL);

   with a check in the store() that the new value is positive and less
than current max?


 I'm also a little puzzled why there is a new API zs_get_max_size_bytes if
 the data is accessible through sysfs?
 Especially if max limit will be (as you propose for [3/3]) through accessed
 through zsmalloc and hence zram needn't access.



  [3/3]
 I concur that the zram limit is best implemented in zsmalloc.
 I am looking forward to that revised code.


> From: Minchan Kim <minchan <at> kernel.org>
> Subject: [RFC 2/3] zsmalloc/zram: add zs_get_max_size_bytes and use it in
> zram
> <http://news.gmane.org/find-root.php?message_id=1407225723%2d23754%2d3%2dgit%2dsend%2demail%2dminchan%40kernel.org>
> Newsgroups: gmane.linux.kernel.mm
> <http://news.gmane.org/gmane.linux.kernel.mm>, gmane.linux.kernel
> <http://news.gmane.org/gmane.linux.kernel>
> Date: 2014-08-05 08:02:02 GMT (5 hours and 4 minutes ago)
>
> Normally, zram user can get maximum memory zsmalloc consumed via
> polling mem_used_total with sysfs in userspace.
>
> But it has a critical problem because user can miss peak memory
> usage during update interval so that gap between them could be
> huge when memory pressure is really heavy.
>
> This patch adds new API zs_get_max_size_bytes in zsmalloc so
> user(ex, zram) doesn't need to poll in short interval to get
> exact value.
>
> User can just see max memory usage once his test workload is
> done. It's pretty handy and accurate.
