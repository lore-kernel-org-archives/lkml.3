Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbaFRXAD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 19:00:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42925 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbaFRXAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 19:00:00 -0400
Date: Wed, 18 Jun 2014 15:59:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jack Miller <millerjo@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, davidlohr@hp.com, miltonm@us.ibm.com,
        anton@au1.ibm.com
Subject: Re: [PATCH 1/3] shm: Make exit_shm work proportional to task
 activity
Message-Id: <20140618155958.84191bb678bea2d37bb97f5b@linux-foundation.org>
In-Reply-To: <1403026067-14272-2-git-send-email-millerjo@us.ibm.com>
References: <1403026067-14272-1-git-send-email-millerjo@us.ibm.com>
	<1403026067-14272-2-git-send-email-millerjo@us.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2014 12:27:45 -0500 Jack Miller <millerjo@us.ibm.com> wrote:

> --- a/include/linux/shm.h
> +++ b/include/linux/shm.h
> @@ -1,6 +1,7 @@
>  #ifndef _LINUX_SHM_H_
>  #define _LINUX_SHM_H_
>  
> +#include <linux/list.h>

yup.  shm.h only compiles by sheer luck - it uses file, task_struct,
user_struct, time_t, pid_t, __user, and probably other things without
including the required header files.

