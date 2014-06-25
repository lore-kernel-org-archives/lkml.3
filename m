Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbaFYLVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:21:22 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:43107 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbaFYLVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:21:21 -0400
MIME-Version: 1.0
In-Reply-To: <CACVxJT_6sp=KDy=jCNBypYapKv_59W8LxFU4OiJEm6gt_SuZKg@mail.gmail.com>
References: <CACVxJT_6sp=KDy=jCNBypYapKv_59W8LxFU4OiJEm6gt_SuZKg@mail.gmail.com>
Date: Wed, 25 Jun 2014 14:21:20 +0300
Message-ID: <CACVxJT8sEaOHJewEcj8HV2CG4m5vGWoZj3i=DsUnEOFKA1wxNw@mail.gmail.com>
Subject: Re: [PATCH] sysctl: Add a feature to drop caches selectively
From: Alexey Dobriyan <adobriyan@gmail.com>
To: mcsim.planeta@gmail.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 2:20 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>> +static void clean_all_dentries_locked(struct dentry *dentry)
>> +{
>> + struct dentry *child;
>> +
>> + list_for_each_entry(child, &dentry->d_subdirs, d_u.d_child) {
>> + clean_all_dentries_locked(child);
>> + }
>> +
>> + clean_mapping(dentry);
>> +}
>
> unbounded recursion = kernel stack overflow
