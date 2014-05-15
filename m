Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbaEOPQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:16:43 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:55811 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752770AbaEOPQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:16:42 -0400
Date: Thu, 15 May 2014 10:16:39 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Vladimir Davydov <vdavydov@parallels.com>
cc: hannes@cmpxchg.org, mhocko@suse.cz, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC 3/3] slub: reparent memcg caches' slabs on memcg
 offline
In-Reply-To: <20140515071650.GB32113@esperanza>
Message-ID: <alpine.DEB.2.10.1405151015330.24665@gentwo.org>
References: <cover.1399982635.git.vdavydov@parallels.com> <6eafe1e95d9a934228e9af785f5b5de38955aa6a.1399982635.git.vdavydov@parallels.com> <alpine.DEB.2.10.1405141119320.16512@gentwo.org> <20140515071650.GB32113@esperanza>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014, Vladimir Davydov wrote:

> I admit that's far not perfect, because kfree is really a hot path,
> where every byte of code matters, but unfortunately I don't see how we
> can avoid this in case we want slab re-parenting.

Do we even know that all objects in that slab belong to a certain cgroup?
AFAICT the fastpath currently do not allow to make that distinction.

> Again, I'd like to hear from you if there is any point in moving in this
> direction, or I should give up and concentrate on some other approach,
> because you'll never accept it.

I wish you would find some other way to do this.

