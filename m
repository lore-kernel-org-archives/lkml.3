Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab3CTInb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 04:43:31 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:48475 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3CTIn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 04:43:28 -0400
MIME-Version: 1.0
X-Originating-IP: [79.102.19.187]
Date: Wed, 20 Mar 2013 09:43:26 +0100
Message-ID: <CAMoAvfEsvah6VELu9D7k1prB2GLhvyubd35tKgBaJdB=P08+pQ@mail.gmail.com>
Subject: Zombie stuck in zap_pid_ns_processes()
From: Caj Larsson <caj@omnicloud.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We are setting up a container using a CLONE_NEWNS linux namespace.
Previously we used the 3.4.4 kernel, which worked fine. After I
upgraded i also experienced races in netlink, which has been resolved
by placing a monitor around the namespace setup. When we upgraded to
Linux 3.8.0 however our init processes does not get reaped when the
namespace is killed and lingers as zombie process under the global
init.

The init has multiple threads when running and two remain in the
zombie. One of them is hung in zap_pid_ns_processes() and has been set
uninterruptible. The other one, which has Tgid=PID, is still in
do_exit().

-- 
Caj Larsson, Omnicloud
