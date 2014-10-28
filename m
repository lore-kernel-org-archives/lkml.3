Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbaJ1LcQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:32:16 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:28708 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaJ1LcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:32:13 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-77-544f7eba6af1
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, jmorris@namei.org,
        dmitry.kasatkin@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v3 0/3] integrity: NULL pointer dereference fixes
Date: Tue, 28 Oct 2014 13:31:21 +0200
Message-id: <cover.1414494901.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFJMWRmVeSWpSXmKPExsVy+t/xy7q76vxDDA63qFnc+ruX2eLL0jqL
	2dObmSzWrV/MZPFyxjx2i8u75rBZfOh5xGbxacUkZgcOj52z7rJ7PDi0mcVj94LPTB4935M9
	+rasYvQ4s+AIu8fnTXIB7FFcNimpOZllqUX6dglcGdtm7WMs2MBe0bP7AlsD40fWLkZODgkB
	E4m7U5tYIGwxiQv31rN1MXJxCAksZZT4/2MnM0hCSKCTSaJ1QjGIzSagJ7Gh+Qc7iC0ikCPx
	6M9rdpAGZoEORomNP64zgSSEBRwlTs+8DdTMwcEioCrRtkwJJMwrYCkxe802JohlchInj01m
	ncDIvYCRYRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSPh82cG4+JjVIUYBDkYlHt4d03xD
	hFgTy4orcw8xSnAwK4nwRsT4hwjxpiRWVqUW5ccXleakFh9iZOLglGpgnDEp4EFnwdsX/DEN
	XmoTTm7bzM4tqKkysXujzcT7M9I1D7beW8ljmVbv3DC/efuJOdK918+vC3z55ZNv2ebz740t
	eGOY5x3bzfvrgFK8wuYjrwtnLAo1DfOeVSX68Y513Jv/R40981mDHMXmvDlWcNtFl83AnPOa
	rOyMo95XZS+I1/55oJcno8RSnJFoqMVcVJwIAFjpR4L9AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recently Jan Kara reported about possible NULL pointer dereference
in IMA and EVM setxattr hooks. This patchset fixes the problem.

http://sourceforge.net/p/linux-ima/mailman/message/32957578

In this version of the patchset we agreed with Mimi to split IMA
patch into two, where the first patch fixes the oops and must go to
the stable and the second patch limits setting of file hash to fix
and log modes and may go to the next kernel version via normal process.

- Dmitry

Dmitry Kasatkin (3):
  ima: check xattr value length and type in the ima_inode_setxattr()
  ima: limit file hash setting by user to fix and log modes
  evm: check xattr value length and type in evm_inode_setxattr()

 security/integrity/evm/evm_main.c     | 11 ++++++++---
 security/integrity/ima/ima_appraise.c | 10 ++++++++--
 security/integrity/integrity.h        |  1 +
 3 files changed, 17 insertions(+), 5 deletions(-)

-- 
1.9.1

