Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161Ab3IDTlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 15:41:52 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:50083 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606Ab3IDTlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 15:41:50 -0400
MIME-Version: 1.0
In-Reply-To: <16226.1378318400@warthog.procyon.org.uk>
References: <cover.1375999914.git.milosz@adfin.com>
	<306cbe63f85921ad40b00e3c7071be19cb6adf04.1375999914.git.milosz@adfin.com>
	<18832.1378311843@warthog.procyon.org.uk>
	<CANP1eJFKGD_h6rcWMWpxp3yOD+rz6p2P0B+2CTcy1taDwM9rdg@mail.gmail.com>
	<18284.1378315570@warthog.procyon.org.uk>
	<CANP1eJEo_dNyYU+ZdvrwKfFPihig9m-Yf_-bUoXym-MF5bGnQg@mail.gmail.com>
	<16226.1378318400@warthog.procyon.org.uk>
Date: Wed, 4 Sep 2013 15:41:48 -0400
Message-ID: <CANP1eJFmMNEr9orps6Dd983sp6QmMfBsMT+dY1CvZ+u0nXKf4w@mail.gmail.com>
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

On Wed, Sep 4, 2013 at 2:13 PM, David Howells <dhowells@redhat.com> wrote:
> Milosz Tanski <milosz@adfin.com> wrote:
>
>> Is it as simple as stick a mutex at the top of the
>> __fscache_check_consistency function before we try to find the object?
>
> You can lock a mutex in a function, but where are you actually going to place
> the mutex struct?  And what other code is going to take it?  To do this, you'd
> have to place the mutex struct in fscache_cookie.  The problem is that you
> have to protect the pointer from fscache_cookie to fscache_object - so placing
> the mutex in fscache_object doesn't help.

David,

I meant lock cookie->lock inside of __fscache_check_consistency in the
beginning of the function. I don't see the need to push this into the
netfs code.

- Milosz
