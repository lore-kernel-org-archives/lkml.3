Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbaIZLxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:53:17 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:54559 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823AbaIZLxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:53:16 -0400
MIME-Version: 1.0
In-Reply-To: <1411725736-49225-1-git-send-email-huishao@microsoft.com>
References: <1411725736-49225-1-git-send-email-huishao@microsoft.com>
Date: Fri, 26 Sep 2014 12:53:15 +0100
Message-ID: <CAL7Bo8HoYU1mbUbw-k0ufj7n8D=Z_hLtf268gKeyACcnZHH5rw@mail.gmail.com>
Subject: Re: [PATCH] Drivers: hv: util: Implement Time Synchronization using
 host time sample
From: Mike Surcouf <mps.surcouf.lkml@gmail.com>
To: Thomas Shao <huishao@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        Olaf Hering <olaf@aepfle.de>, Robo Bot <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/* helper function to call adjtimex command in user mode */
> +static void run_adjtimex_cmd(s64 tickvalue)
> +{
> +       char *argv[4], *envp[3];
> +       char str_tickvalue[20];
> +
> +       sprintf(str_tickvalue, "%lld", tickvalue);
> +
> +       argv[0] = "/sbin/adjtimex";
> +       argv[1] = "-t";
> +       argv[2] = str_tickvalue;
> +       argv[3] = NULL;
> +
> +       envp[0] = "HOME=/";
> +       envp[1] = "PATH=/sbin:/bin:/usr/sbin:/usr/bin";
> +       envp[2] = NULL;
> +
> +       call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
> +}


What happens when adjtimex is not present?
Is there no kernel space function for that?
Does this patch affect "not setting correct time on restore" or "not
setting correct time on  live migration" bug?

Thanks

Mike
