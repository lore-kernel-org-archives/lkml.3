Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbaCLVAd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 17:00:33 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:41328 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbaCLVAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 17:00:31 -0400
Message-ID: <5320CAEC.6030008@amacapital.net>
Date: Wed, 12 Mar 2014 14:00:28 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        tj@kernel.org
CC: ssorce@redhat.com, jkaluza@redhat.com, lpoetter@redhat.com, kay@redhat.com
Subject: Re: [PATCH 2/2] net: Implement SO_PEERCGROUP
References: <1394657163-7472-1-git-send-email-vgoyal@redhat.com> <1394657163-7472-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1394657163-7472-3-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 01:46 PM, Vivek Goyal wrote:
> Implement SO_PEERCGROUP along the lines of SO_PEERCRED. This returns the
> cgroup of first mounted hierarchy of the task. For the case of client,
> it represents the cgroup of client at the time of opening the connection.
> After that client cgroup might change.

Even if people decide that sending cgroups over a unix socket is a good
idea, this API has my NAK in the strongest possible sense, for whatever
my NAK is worth.

IMO SO_PEERCRED is a disaster.  Calling send(2) or write(2) should
*never* imply the use of a credential.  A program should always have to
*explicitly* request use of a credential.  What you want is SCM_CGROUP.

(I've found privilege escalations before based on this observation, and
I suspect I'll find them again.)


Note that I think that you really want SCM_SOMETHING_ELSE and not
SCM_CGROUP, but I don't know what the use case is yet.

--Andy
