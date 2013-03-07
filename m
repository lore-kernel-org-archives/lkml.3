Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab3CGIVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 03:21:50 -0500
Received: from mx0.parallels.com ([199.115.104.20]:42730 "EHLO
	mx0.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab3CGIVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 03:21:49 -0500
Message-ID: <51384E3F.6070609@parallels.com>
Date: Thu, 7 Mar 2013 12:22:23 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH for 3.9] memcg: initialize kmem-cache destroying work
 earlier
References: <20130307074853.26272.83618.stgit@zurg>
In-Reply-To: <20130307074853.26272.83618.stgit@zurg>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2013 11:48 AM, Konstantin Khlebnikov wrote:
> This patch fixes warning from lockdep caused by calling cancel_work_sync()
> for uninitialized struct work. This path has been triggered by destructon
> kmem-cache hierarchy via destroying its root kmem-cache.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: Glauber Costa <glommer@parallels.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> 
I see no reason not to do the work initialization earlier, so
ACK
