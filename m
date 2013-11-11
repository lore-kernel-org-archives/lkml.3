Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab3KKPlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:41:31 -0500
Received: from m53-178.qiye.163.com ([123.58.178.53]:52799 "EHLO
	m53-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab3KKPlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:41:23 -0500
From: Li Wang <liwang@ubuntukylin.com>
To: linux-kernel@vger.kernel.org
Cc: ceph-devel@vger.kernel.org, Sage Weil <sage@inktank.com>,
        linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
        Milosz Tanski <milosz@adfin.com>, Li Wang <liwang@ubuntukylin.com>
Subject: [PATCH 0/7] Cifs and Ceph: Uncache single no-data page in readpage()
Date: Mon, 11 Nov 2013 23:27:22 +0800
Message-Id: <cover.1384183054.git.liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQUhVQ0lCQkJCQklITEtNS05PTFdZCQ4XHghZQV
	koKz0kKzooKCQyNSQzPjo*PilBS1VLQDYjJCI#KCQyNSQzPjo*PilBS1VLQCsvKSQiPigkMjUkMz
	46Pz4pQUtVS0A4NC41LykiJDg1QUtVS0ApPjwyNDUkOigyOkFLVUtAKyk0LTI1OD4kPC46NTw*ND
	U8QUtVS0A*IjU6NjI4JDIrJDU0JDI1JDM#Oj8#KUFLVUtANi43LzIkKTgrLyQ*Mj09Pik#NS8kMj
	UkMz46Pz4pQUlVS0AyKyQvND86IiQ4NS8kSyRKS0tBS1VLQDIrJE4kNjI1Li8#JDg1LyRLJEpLQU
	tVS0AyKyRISyQ2MjUuLz4kODUvJEskTktBS1VLQDIrJEokMzQuKSQ4NS8kSyRKS0tBS1VLQDIrJE
	okNjI1Li8#JDg1LyRLJEpLQUtVS0AoLjkkPkFKVU5OQD01JCguOSQ#NSw0KT8oJDM3MSRKS0tJS0
	pBS1VJQ1kG
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSENP
	SkNPT0NLT0tJVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUpCT043V1kSC1lBWUpJSlVISFVJTk5VSktZBg++
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the page allocated into fscache in readpage() 
for Cifs and Ceph does not be uncached if no data read due
to io error. This patch fixes this. fscache_readpages_cancel() 
is for this kind of job but taking list read * as input, so
a new routine take page * as input is introduced. 

Li Wang (7):
  Fscache: Introduce new API fscache_readpage_cancel()
  Fscache: Implement uncaching single no-data page
  Ceph: Introduce routine for uncaching single no-data page
  Ceph: Uncaching no-data page in readpage()
  Cifs: Introduce routine for uncaching single no-data page
  Cifs: Implement uncaching single no-data page
  Cifs: Uncaching no-data page in readpage()

 fs/ceph/addr.c          |    1 +
 fs/ceph/cache.h         |   13 +++++++++++++
 fs/cifs/file.c          |    4 +++-
 fs/cifs/fscache.c       |    7 +++++++
 fs/cifs/fscache.h       |   13 +++++++++++++
 fs/fscache/page.c       |    8 ++++++++
 include/linux/fscache.h |   11 +++++++++++
 7 files changed, 56 insertions(+), 1 deletion(-)

-- 
1.7.9.5

