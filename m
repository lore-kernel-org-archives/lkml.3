Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab3BVNmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 08:42:09 -0500
Received: from mx0.parallels.com ([199.115.104.20]:53175 "EHLO
	mx0.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab3BVNmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 08:42:06 -0500
Message-ID: <512775CA.2030603@parallels.com>
Date: Fri, 22 Feb 2013 17:42:34 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Aaron Tomlin <atomlin@redhat.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Rik <riel@redhat.com>
Subject: Re: [PATCH] mm: slab: Verify the nodeid passed to ____cache_alloc_node
References: <943811281.6485888.1361484478519.JavaMail.root@redhat.com>
In-Reply-To: <943811281.6485888.1361484478519.JavaMail.root@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 02:07 AM, Aaron Tomlin wrote:
> The addition of this BUG_ON should make debugging easier.
> While I understand that this code path is "hot", surely
> it is better to assert the condition than to wait until
> some random NULL pointer dereference or page fault. If the
> caller passes an invalid nodeid, at this stage in my opinion
> it's already a BUG.
If you assert with VM_BUG_ON, it will be active on debugging kernels
only, which I believe is better suited for a hotpath.

