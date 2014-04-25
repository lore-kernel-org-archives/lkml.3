Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaDYP6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:58:39 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:52592 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaDYP6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:58:36 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 25 Apr 2014 08:58:15 -0700
Message-ID: <CALCETrVSaboa0Y2v_sTbSz3xOxOZ-6jSq_D7DyQXMRB9VXJB8w@mail.gmail.com>
Subject: pid ns feature request
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unless I'm missing some trick, it's currently rather painful to mount
a namespace /proc.  You have to actually be in the pid namespace to
mount the correct /proc instance, and you can't unmount the old /proc
until you've mounted the new /proc.  This means that you have to fork
into the new pid namespace before you can finish setting it up.

Would it make sense to add a mount option to procfs to request a mount
for pid_ns_for_children instead of task_active_pid_ns?

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
