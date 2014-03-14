Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbaCNPCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:02:12 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:60997 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753644AbaCNPCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:02:10 -0400
Message-ID: <532319EC.8000509@hurleysoftware.com>
Date: Fri, 14 Mar 2014 11:02:04 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Sree Harsha Totakura <sreeharsha@totakura.in>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: pppd service crash in linux-3.13.6
References: <531A37FF.4000509@totakura.in> <531DEEA6.4090808@totakura.in> <531E111A.8040207@hurleysoftware.com> <20140313170622.GA31206@redhat.com> <5321F113.7090000@hurleysoftware.com> <53230FE5.9020204@hurleysoftware.com>
In-Reply-To: <53230FE5.9020204@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2014 10:19 AM, Peter Hurley wrote:
> Plus, proc_exit_connector() uses netlink which uses user_ns.

Actually, I think this can be safely ignored since if the
netlink socket was tied to a user_ns which has just been
freed in exit_task_namespace() then the socket could not
be open in another process (otherwise the net_ns would
still have an open reference).
