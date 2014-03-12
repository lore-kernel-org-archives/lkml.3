Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbaCLU4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 16:56:33 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:34235 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbaCLU4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 16:56:31 -0400
Message-ID: <5320C9FC.6070301@amacapital.net>
Date: Wed, 12 Mar 2014 13:56:28 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        tj@kernel.org
CC: ssorce@redhat.com, jkaluza@redhat.com, lpoetter@redhat.com, kay@redhat.com
Subject: Re: [PATCH 0/2][V2] net: Implement SO_PEERCGROUP to get cgroup of
 peer
References: <1394657163-7472-1-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1394657163-7472-1-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 01:46 PM, Vivek Goyal wrote:
> Hi,
> 
> This is V2 of patches. Fixed the function format issue and also I was using
> CONFIG_CGROUP instead of CONFIG_CGROUPS. That led to crash at boot. Fixed that.
> 
> Some applications like sssd want to know the cgroup of connected peer over
> unix stream socket. They want to use this information to map the cgroup to 
> the container client belongs to and then decide what kind of policies apply
> on the container.
> 

Can you explain what the use case is?

My a priori opinion is that this is a terrible idea.  cgroups are a
nasty interface, and letting knowledge of cgroups leak into the programs
that live in the groups (as opposed to the cgroup manager) seems like a
huge mistake to me.

If you want to know where in the process hierarchy a message sender is,
add *that* and figure out how to fix the races (it shouldn't be that hard).

--Andy
