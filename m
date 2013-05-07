Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab3EGKre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 06:47:34 -0400
Received: from intranet.asianux.com ([58.214.24.6]:9512 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728Ab3EGKrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 06:47:33 -0400
X-Spam-Score: -100.8
Message-ID: <5188DB93.2080504@asianux.com>
Date: Tue, 07 May 2013 18:46:43 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: tj@kernel.org, Li Zefan <lizefan@huawei.com>
CC: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Suggestion] kernel/cgroup.c: about kfree after 'get_new_cssid'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

After call get_new_cssid(), I can not find the related free function
(it seems free_css_id() is for that, but not used).

The memory location is:
  get_new_cssid() --> kzalloc() for 'struct css_id'
  get_new_cssid() --> idr_alloc() for 'ss->idr'

One work flow:
  cgroup_load_subsys() --> cgroup_init_idr() --> get_new_cssid()
  when get_new_cssid() fails, it will:
  cgroup_load_subsys() --> cgroup_unload_subsys() --> idr_destroy(),
  and also:
  cgroup_load_subsys() --> cgroup_unload_subsys() --> ss->css_free();
    ('css_free' may 'debug_css_free', or 'freezer_css_free' ...)

It seems the work flow above is not 'kfree' 'struct css_id', is it true?

BTW: I also guess, for cgroup_init_idr() in cgroup_init(), need check
the return value.

Please help check.


Thanks.

--
 Chen Gang

 Asianux Corporation
