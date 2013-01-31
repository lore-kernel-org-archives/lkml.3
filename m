Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab3AaFPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 00:15:49 -0500
Received: from relay.parallels.com ([195.214.232.42]:52631 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab3AaFPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 00:15:48 -0500
Message-ID: <5109FDF7.60002@parallels.com>
Date: Thu, 31 Jan 2013 09:15:35 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: <linux-nfs@vger.kernel.org>, <Trond.Myklebust@netapp.com>,
        <linux-kernel@vger.kernel.org>, <devel@openvz.org>
Subject: Re: [RFC PATCH 0/4] SUNRPC: rework cache upcall to avoid NFSd root
 swapping
References: <20130115080402.2996.74320.stgit@localhost.localdomain> <20130130230052.GB16158@fieldses.org>
In-Reply-To: <20130130230052.GB16158@fieldses.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.18.163]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

31.01.2013 03:00, J. Bruce Fields пишет:
> On Tue, Jan 15, 2013 at 11:09:23AM +0300, Stanislav Kinsbursky wrote:
>> The main idea of this patch set is to call cache request not on kthread
>> upcall, but on userspace daemon cache_read call. This fixes the problem with
>> gaining of wrong dentry path after calling d_path() in kthread root context
>> (svc_export_request() callback), which always work in init root context, but
>> containers can work in "root jail" - i.e. have it's own nested root.
>
> Sorry for the delay.  This looks good to me--committing pending some
> testing.
>
> What's left now for basic containerized nfsd support?
>

Sure, thanks!
Not that many patches left: NFSd fs per-net (to get the proper context from the superblock), disabling UMH tracker for a while (again selecting proper root 
issue) and removing of error patch for state tracker in current net != &init_net.
They are simple so I'm going to re-send them soon. Just wanna work a bit more on per-net service shutdown first since it looks more urgent.


-- 
Best regards,
Stanislav Kinsbursky
