Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbaIYSKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 14:10:10 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:57076 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbaIYSKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 14:10:08 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: riya khanna <riyakhanna1983@gmail.com>
Cc: LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Tejun Heo <tj@kernel.org>, Seth Forshee <seth.forshee@canonical.com>,
        linux-kernel@vger.kernel.org, Serge Hallyn <serge.hallyn@ubuntu.com>
References: <CALRD3qKmpzJCRszkG_S9Z3XgoTGWVMFd7FqeJh+W-9pZqPVhCg@mail.gmail.com>
	<87bnq5vcbl.fsf@x220.int.ebiederm.org>
	<CALRD3qKPJHmmY2DSNNfNKzmLihDLm9fgBQprCXNMHVOArV4iuw@mail.gmail.com>
	<20140924163740.GD3865@ubuntumail>
	<8738bglxsf.fsf_-_@x220.int.ebiederm.org>
	<E8CD8839-8FC9-4404-863B-38F36F7D4328@gmail.com>
	<871tr0hcfo.fsf@x220.int.ebiederm.org>
	<CALRD3qLYAc+K8e1xYb27ipi4KyGRmTxokPCHN0L_zta=Cy9sCQ@mail.gmail.com>
	<CALRD3qKU5gOi5K53ysOgF9Re+MjMLfcTYEK_3gq3ns2HNLkUFw@mail.gmail.com>
Date: Thu, 25 Sep 2014 11:09:43 -0700
In-Reply-To: <CALRD3qKU5gOi5K53ysOgF9Re+MjMLfcTYEK_3gq3ns2HNLkUFw@mail.gmail.com>
	(riya khanna's message of "Thu, 25 Sep 2014 10:40:10 -0500")
Message-ID: <87eguzefmg.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19mGWPDtkQlowU1HwNt1vAQtsxB7cz18AA=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.4 XM_Superlative01 Best-rated language
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3249]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;riya khanna <riyakhanna1983@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: Using devices in Containers
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

riya khanna <riyakhanna1983@gmail.com> writes:

> Is there a plan or work-in-progress to add namespace tags to other
> classes in sysfs similar to net? Does it make sense to add namespace
> tags to kobjects?

Currently the a general nack from gregkh on such work.

Given that sysfs is almost never a fast path I suspect it makes most
sense to filter sysfs in some way (aka bind mounts or fuse) and present
the results to the container.

At the point this is something that we are using a lot and have
demonstrated the usefulness of it and it appears a kernel level
solution would be better it would be worth reopening the disucssion.

Eric
