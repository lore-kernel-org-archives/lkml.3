Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbaLBSku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:40:50 -0500
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:39132 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752442AbaLBSkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:40:49 -0500
From: Roman Gushchin <klamm@yandex-team.ru>
To: Tejun Heo <tj@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
In-Reply-To: <20141202165553.GB10918@htj.dyndns.org>
References: <1417193274-20679-1-git-send-email-klamm@yandex-team.ru> <20141202165553.GB10918@htj.dyndns.org>
Subject: Re: [PATCH 3.10] cgroup: break infinite loop in __css_tryget()
MIME-Version: 1.0
Message-Id: <119181417545645@webcorp02h.yandex-team.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 02 Dec 2014 21:40:45 +0300
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Tejun!

02.12.2014, 19:56, "Tejun Heo" <tj@kernel.org>:
> Hello, Roman.
>
> On Fri, Nov 28, 2014 at 07:47:54PM +0300, Roman Gushchin wrote:
>> šIf cgroup_destroy_locked() sets the css refcount to a negative value,
>> šwe get an infinite loop in __css_tryget().
>>
>> šIn this case css_refcnt() returns modified (non-negative value), so
>> šboth (t == v) and (t < 0) conditions are always false.
>
> I don't follow. šThe count is biased and modified by unbiasing iff the
> value is negative. šHere, @v is the unbiased value and @t is the
> verbatim value. šIf @v is different from @t due to unbiasing, @t must
> be negative satisfying the second condition and returning NULL, no?

Yep. I missed that we compare t with 0 (not v).
Thanks!
