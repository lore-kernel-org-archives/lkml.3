Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab3IDSE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 14:04:27 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:61517 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab3IDSEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 14:04:25 -0400
MIME-Version: 1.0
In-Reply-To: <18284.1378315570@warthog.procyon.org.uk>
References: <cover.1375999914.git.milosz@adfin.com>
	<306cbe63f85921ad40b00e3c7071be19cb6adf04.1375999914.git.milosz@adfin.com>
	<18832.1378311843@warthog.procyon.org.uk>
	<CANP1eJFKGD_h6rcWMWpxp3yOD+rz6p2P0B+2CTcy1taDwM9rdg@mail.gmail.com>
	<18284.1378315570@warthog.procyon.org.uk>
Date: Wed, 4 Sep 2013 14:04:24 -0400
Message-ID: <CANP1eJEo_dNyYU+ZdvrwKfFPihig9m-Yf_-bUoXym-MF5bGnQg@mail.gmail.com>
Subject: Re: [PATCH 2/5] new fscache interface to check cache consistency
From: Milosz Tanski <milosz@adfin.com>
To: David Howells <dhowells@redhat.com>
Cc: Hongyi Jia <jiayisuse@gmail.com>, ceph-devel <ceph-devel@vger.kernel.org>,
        Sage Weil <sage@inktank.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        "linux-cachefs@redhat.com" <linux-cachefs@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

Is it as simple as stick a mutex at the top of the
__fscache_check_consistency function before we try to find the object?
This code should be called from a context that can sleep, in the Ceph
code we call it from a delayed work queue (revalidate queue).

-- Milosz

On Wed, Sep 4, 2013 at 1:26 PM, David Howells <dhowells@redhat.com> wrote:
> Milosz Tanski <milosz@adfin.com> wrote:
>
>> If the cache is withdrawn and we're starting anew I would consider
>> that to okay. I would consider an empty page cache for a cookie to be
>> consistent since there's nothing stale that I can read. Unless there's
>> another synchronization issue that I'm missing in fscache.
>
> The problem is that the fscache_object struct may be deallocated whilst you're
> using it.
>
> David
