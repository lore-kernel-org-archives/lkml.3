Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbaIZPou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:44:50 -0400
Received: from resqmta-ch2-01v.sys.comcast.net ([69.252.207.33]:44897 "EHLO
	resqmta-ch2-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754127AbaIZPot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:44:49 -0400
Date: Fri, 26 Sep 2014 10:44:47 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] cpuset: convert callback_mutex to a spinlock
In-Reply-To: <778e648ce62511c7aff225ca067e0abedb247f25.1411741632.git.vdavydov@parallels.com>
Message-ID: <alpine.DEB.2.11.1409261039410.3870@gentwo.org>
References: <cover.1411741632.git.vdavydov@parallels.com> <778e648ce62511c7aff225ca067e0abedb247f25.1411741632.git.vdavydov@parallels.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Sep 2014, Vladimir Davydov wrote:

> The callback_mutex is only used to synchronize reads/updates of cpusets'
> flags and cpu/node masks. These operations should always proceed fast so
> there's no reason why we can't use a spinlock instead of the mutex.

Checked that and given the other restrictions already on the use of
callback_mutex this is to be expected.

Acked-by: Christoph Lameter <cl@linux.com>

