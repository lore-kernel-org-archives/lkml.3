Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab3LSOE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:04:27 -0500
Received: from m59-178.qiye.163.com ([123.58.178.59]:44488 "EHLO
	m59-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3LSOEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:04:25 -0500
From: Li Wang <liwang@ubuntukylin.com>
To: ceph-devel@vger.kernel.org
Cc: Sage Weil <sage@inktank.com>, Milosz Tanski <milosz@adfin.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Wang <liwang@ubuntukylin.com>
Subject: [PATCH 0/2] ceph fscache: uncaching single no data page when error
Date: Thu, 19 Dec 2013 06:03:47 -0800
Message-Id: <cover.1387461299.git.liwang@ubuntukylin.com>
X-Mailer: git-send-email 1.7.9.5
X-HM-Spam-Status: e1koWUFPN1dZCBgUCR5ZQUpOVUNJQkJCQkJJSExLTUtOTldZCQ4XHghZQV
	koKz0kKzooKCQyNSQzPjo*PilBS1VLQDYjJCI#KCQyNSQzPjo*PilBS1VLQCsvKSQiPigkMjUkMz
	46Pz4pQUtVS0A4NC41LykiJDg1QUtVS0ApPjwyNDUkOigyOkFLVUtAKyk0LTI1OD4kMy41OjVBS1
	VLQD8iNTo2MjgkMiskNTQkMjUkMz46Pz4pQUtVS0ApPjo3JDIrJDI1JCk5NyQyNSQzPjo*PilBSk
	lVS0A2LjcvMiQpOCsvJD8yPT0#KT41LyQyNSQzPjo*PilBSVVLQDIrJC80PzoiJDg1LyRLJEpLS0
	FLVUtAMiskTiQ2MjUuLz4kODUvJEskSktBS1VLQDIrJEokNjI1Li8#JDg1LyRLJEpLQUtVS0AyKy
	RKJDM0LikkODUvJEskSktLQUtVS0AyKyRISyQ2MjUuLz4kODUvJEskTktBS1VLQCguOSQ#QUpVTk
	5APTUkKC45JD41LDQpPygkMzcxJEpLS0lLSkFLVUlDWQY+
X-HM-Sender-Digest: e1kSHx4VD1lBWUc6MQg6Cjo4LDo4EDorKjhIOj4qOkMwCjFVSlVKSENM
	T01KQ01JTU9IVTMWGhIXVRcSDBoVHDsOGQ4VDw4QAhcSFVUYFBZFWVdZDB4ZWUEdGhcIHldZCAFZ
	QUpISU83V1kSC1lBWU1KVUpDTFVOT1VCWQY+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if one new page allocated into fscache in readpage(), however, 
with no data read into due to error encountered during reading from OSDs, 
the slot in fscache is not uncached. This patch fixes this.

Li Wang (2):
  ceph: Introduce a routine for uncaching single no data page from
    fscache
  ceph: Uncaching no data page from fscache in readpage()

 fs/ceph/addr.c  |    1 +
 fs/ceph/cache.h |   13 +++++++++++++
 2 files changed, 14 insertions(+)

-- 
1.7.9.5

