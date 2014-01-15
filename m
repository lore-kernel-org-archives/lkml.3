Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaAOOLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 09:11:47 -0500
Received: from forward13.mail.yandex.net ([95.108.130.120]:59530 "EHLO
	forward13.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaAOOLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 09:11:44 -0500
From: Victor Porton <porton@narod.ru>
Envelope-From: porton@yandex.ru
To: Michal Hocko <mhocko@suse.cz>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups mailinglist <cgroups@vger.kernel.org>
In-Reply-To: <20140115135930.GK8782@dhcp22.suse.cz>
References: <135711389759165@web22h.yandex.ru> <20140115135930.GK8782@dhcp22.suse.cz>
Subject: Re: Notifying on empty cgroup
MIME-Version: 1.0
Message-Id: <409331389795100@web18j.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Wed, 15 Jan 2014 16:11:40 +0200
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

15.01.2014, 15:59, "Michal Hocko" <mhocko@suse.cz>:
> [CCing cgroups mailing list]
> On Wed 15-01-14 06:12:45, Victor Porton wrote:
>
>> šI want to write software which needs to receive a signal when the cgroup
>> šcreated by it becomes empty. (After this the empty cgroup should be deleted
>> šjust not to clutter the memory.)
>>
>> šIf the kernel does not support such notifications, it should be improved.
>> šThis functionality is crucial for some kinds of software.
>>
>> šThere is /sys/fs/cgroup/systemd/release_agent but I don't understand how to
>> šuse it. I don't understand why we would need it at all.
>
> "1.4 What does notify_on_release do ?" in
> Documentation/cgroups/cgroups.txt the kernel source doesn't help?

I've read it. I understand what it does. I don't understand how to use it in practice nor why it is done this way.

>> šStarting a binary on emptying a cgroup with the purpose to notify an other
>> šbinary looks like a big overkill.
>
> the binary can do rmdir which is what you want, no?

I suppose a base package should do that, not my specific software. Do I understand right?

>> šAlso my program should work in userspace without the need to use
>> šrelease_agent which can be accessed only by root.
>
> The release_agent is global for all groups so the program doesn't have
> to care.

Again: What MY program should do?

>> šNote that my work is related with sandboxing software (running a program in
>> šclosed environment, so that it would be unable for example to remove user's
>> šfiles).
>>
>> šSee also
>> šhttp://portonsoft.wordpress.com/2014/01/11/toward-robust-linux-sandbox/
>>
>> š--
>> šVictor Porton - http://portonvictor.org
>> š--
>> šTo unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> šthe body of a message to majordomo@vger.kernel.org
>> šMore majordomo info at šhttp://vger.kernel.org/majordomo-info.html
>> šPlease read the FAQ at šhttp://www.tux.org/lkml/
>
> --
> Michal Hocko
> SUSE Labs

-- 
Victor Porton - http://portonvictor.org
