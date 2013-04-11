Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934901Ab3DKQmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 12:42:33 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40875 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934717Ab3DKQma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 12:42:30 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Ming Lei <ming.lei@canonical.com>
References: <20130406165600.GA29660@kroah.com> <87y5cpvhaz.fsf@xmission.com>
	<20130411161936.GA390@kroah.com>
Date: Thu, 11 Apr 2013 09:41:54 -0700
In-Reply-To: <20130411161936.GA390@kroah.com> (Greg KH's message of "Thu, 11
	Apr 2013 09:19:36 -0700")
Message-ID: <87d2u110kt.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19EWw6Ga4b2Kom3jVibz+uzkgxBYfhlC/0=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH] driver core: add uid and gid to devtmpfs
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> On Wed, Apr 10, 2013 at 09:10:12PM -0700, Eric W. Biederman wrote:
>> Still it approaches being twisted to have files like
>> /sys/class/net/eth0/uevent that anyone can read that will only return
>> values in the initial user namespace.
>
> Side note, I don't think that ethernet network devices have uids :)

I didn't think any devices had uids... :)

The generic uevent file was the first place I could think of where we
output this information to userspace.  And I don't think that uevent file
is specific network devices.

There isn't anything that limits our netlink messages to clients in the
initial user namespace either.

Nothing huge, but there are some goofy kernel/user interaction cases
that  show up when you add this functionality.

Eric
