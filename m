Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbaEFNbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:31:50 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:65453 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbaEFNbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:31:47 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-a7-5368e441e40f
Message-id: <5368E46B.9050708@samsung.com>
Date: Tue, 06 May 2014 16:32:27 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: linux-security-module <linux-security-module@vger.kernel.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: viro@ZenIV.linux.org.uk,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: IMA & truncate
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrALMWRmVeSWpSXmKPExsVy+t/xq7qOTzKCDX7N4La4vGsOm8WHnkds
	Fuf/Hme1+LRiErMDi8eDQ5tZPD5vkvPY9OQtUwBzFJdNSmpOZllqkb5dAlfGq5mHmQqeMFfc
	vT+BsYGxibmLkZNDQsBEon3XHlYIW0ziwr31bF2MXBxCAksZJXa+/ATlNDJJbFo5mxXCmcUo
	8f/BRrB2XgEtiVcPG8HaWQRUJW78+c4EYrMJ6ElsaP7B3sXIwSEqECHx+IIQRLmgxI/J91hA
	bBGBLIkNc5rZQGxmgXCJNWfesoGUCwuIS7T8VIQI60jsb50GVSIvsXnNW7CtQkCbuteuZYM4
	WlHi9ORzzBMYBWch2TALSfssJO0LGJlXMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoSE8tcd
	jEuPWR1iFOBgVOLhXSCTESzEmlhWXJl7iFGCg1lJhFf8PlCINyWxsiq1KD++qDQntfgQIxMH
	p1QDo8OcZy//GdZN32asP4FT4cnvToUilRPHTf/cWuJuZDy99emLOvlC3ViB5K/J68w4fv/t
	n71c9e2GO7EXV9nHbPrwel168p/NjRV8uxQaWBYySPG7sF5Wtj9feeLzYbvqp1Uzq49taWI0
	qtw/4XvS/oXrW09FSk3f1zv54yGpp8fnT7bnvy68I1SJpTgj0VCLuag4EQBXlvKXQwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have discovered one IMA related issue.

IMA file hash is re-calculate if needed on file close.

It works with ftruncate(fd, length) syscall, because it operates on
"opened" file.
Recalculation is happening on file close.

truncate(path, length) syscall works with path and no file open/close
takes place.
Recalculation does not happen.
IMA denies file access later.

It looks like vfs_truncate() should possibly call IMA to recalculate the
hash.

- Dmitry

