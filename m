Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab3AZUOV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 15:14:21 -0500
Received: from mail-ia0-f179.google.com ([209.85.210.179]:41383 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab3AZUOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 15:14:18 -0500
Date: Sat, 26 Jan 2013 15:14:35 -0500
From: Jake Champlin <jake.champlin.27@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devendra.aaru@gmail.com, jake.champlin.27@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: csr: csr_msgconv: Fixed Multiple Coding Style Issues
Message-ID: <20130126201431.GA18436@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resolved 150 Style Errors and 202 Coding Style Warnings.

Signed-off-by: Jake Champlin <jake.champlin.27@gmail.com>
---
 drivers/staging/csr/csr_msgconv.c | 391 ++++++++++++++++----------------------
 1 file changed, 168 insertions(+), 223 deletions(-)

diff --git a/drivers/staging/csr/csr_msgconv.c b/drivers/staging/csr/csr_msgconv.c
index db5e845..4f96edb 100644
--- a/drivers/staging/csr/csr_msgconv.c
+++ b/drivers/staging/csr/csr_msgconv.c
@@ -1,10 +1,10 @@
 /*****************************************************************************
 
-            (c) Cambridge Silicon Radio Limited 2010
-            All rights reserved and confidential information of CSR
+	(c) Cambridge Silicon Radio Limited 2010
+	All rights reserved and confidential information of CSR
 
-            Refer to LICENSE.txt included with this source for details
-            on the license terms.
+	Refer to LICENSE.txt included with this source for details
+	on the license terms.
 
 *****************************************************************************/
 
@@ -19,273 +19,218 @@ static CsrMsgConvEntry *converter;
 
 CsrMsgConvPrimEntry *CsrMsgConvFind(u16 primType)
 {
-    CsrMsgConvPrimEntry *ptr = NULL;
-
-    if (converter)
-    {
-        ptr = converter->profile_converters;
-        while (ptr)
-        {
-            if (ptr->primType == primType)
-            {
-                break;
-            }
-            else
-            {
-                ptr = ptr->next;
-            }
-        }
-    }
-
-    return ptr;
+	CsrMsgConvPrimEntry *ptr = NULL;
+
+	if (converter) {
+		ptr = converter->profile_converters;
+	while (ptr) {
+		if (ptr->primType == primType)
+			break;
+		else
+			ptr = ptr->next;
+	}
+	}
+
+	return ptr;
 }
 
-static const CsrMsgConvMsgEntry *find_msg_converter(CsrMsgConvPrimEntry *ptr, u16 msgType)
+static const CsrMsgConvMsgEntry *find_msg_converter(CsrMsgConvPrimEntry *ptr,
+		u16 msgType)
 {
-    const CsrMsgConvMsgEntry *cv = ptr->conv;
-    if (ptr->lookupFunc)
-    {
-        return (const CsrMsgConvMsgEntry *) ptr->lookupFunc((CsrMsgConvMsgEntry *) cv, msgType);
-    }
-
-    while (cv)
-    {
-        if (cv->serFunc == NULL)
-        {
-            /* We've reached the end of the chain */
-            cv = NULL;
-            break;
-        }
-
-        if (cv->msgType == msgType)
-        {
-            break;
-        }
-        else
-        {
-            cv++;
-        }
-    }
-
-    return cv;
+	const CsrMsgConvMsgEntry *cv = ptr->conv;
+	if (ptr->lookupFunc)
+		return (const CsrMsgConvMsgEntry *)
+			ptr->lookupFunc((CsrMsgConvMsgEntry *) cv, msgType);
+
+	while (cv) {
+		if (cv->serFunc == NULL) {
+			/* We've reached the end of the chain */
+			cv = NULL;
+			break;
+		}
+
+		if (cv->msgType == msgType)
+			break;
+		else
+			cv++;
+	}
+
+	return cv;
 }
 
 static void *deserialize_data(u16 primType,
-    size_t length,
-    u8 *data)
+	size_t length,
+	u8 *data)
 {
-    CsrMsgConvPrimEntry *ptr;
-    u8 *ret;
-
-    ptr = CsrMsgConvFind(primType);
-
-    if (ptr)
-    {
-        const CsrMsgConvMsgEntry *cv;
-        u16 msgId = 0;
-        size_t offset = 0;
-        CsrUint16Des(&msgId, data, &offset);
-
-        cv = find_msg_converter(ptr, msgId);
-        if (cv)
-        {
-            ret = cv->deserFunc(data, length);
-        }
-        else
-        {
-            ret = NULL;
-        }
-    }
-    else
-    {
-        ret = NULL;
-    }
-
-    return ret;
+	CsrMsgConvPrimEntry *ptr;
+	u8 *ret;
+
+	ptr = CsrMsgConvFind(primType);
+
+	if (ptr) {
+		const CsrMsgConvMsgEntry *cv;
+		u16 msgId = 0;
+		size_t offset = 0;
+		CsrUint16Des(&msgId, data, &offset);
+
+		cv = find_msg_converter(ptr, msgId);
+		if (cv)
+			ret = cv->deserFunc(data, length);
+		else
+			ret = NULL;
+	} else
+		ret = NULL;
+
+	return ret;
 }
 
 static size_t sizeof_message(u16 primType, void *msg)
 {
-    CsrMsgConvPrimEntry *ptr = CsrMsgConvFind(primType);
-    size_t ret;
-
-    if (ptr)
-    {
-        const CsrMsgConvMsgEntry *cv;
-        u16 msgId = *(u16 *) msg;
-
-        cv = find_msg_converter(ptr, msgId);
-        if (cv)
-        {
-            ret = cv->sizeofFunc(msg);
-        }
-        else
-        {
-            ret = 0;
-        }
-    }
-    else
-    {
-        ret = 0;
-    }
-
-    return ret;
+	CsrMsgConvPrimEntry *ptr = CsrMsgConvFind(primType);
+	size_t ret;
+
+	if (ptr) {
+		const CsrMsgConvMsgEntry *cv;
+		u16 msgId = *(u16 *) msg;
+
+		cv = find_msg_converter(ptr, msgId);
+		if (cv)
+			ret = cv->sizeofFunc(msg);
+		else
+			ret = 0;
+	} else
+		ret = 0;
+
+	return ret;
 }
 
 static u8 free_message(u16 primType, u8 *data)
 {
-    CsrMsgConvPrimEntry *ptr;
-    u8 ret;
-
-    ptr = CsrMsgConvFind(primType);
-
-    if (ptr)
-    {
-        const CsrMsgConvMsgEntry *cv;
-        u16 msgId = *(u16 *) data;
-
-        cv = find_msg_converter(ptr, msgId);
-        if (cv)
-        {
-            cv->freeFunc(data);
-            ret = TRUE;
-        }
-        else
-        {
-            ret = FALSE;
-        }
-    }
-    else
-    {
-        ret = FALSE;
-    }
-
-    return ret;
+	CsrMsgConvPrimEntry *ptr;
+	u8 ret;
+
+	ptr = CsrMsgConvFind(primType);
+
+	if (ptr) {
+		const CsrMsgConvMsgEntry *cv;
+		u16 msgId = *(u16 *) data;
+
+		cv = find_msg_converter(ptr, msgId);
+	if (cv) {
+		cv->freeFunc(data);
+		ret = TRUE;
+	} else
+		ret = FALSE;
+	} else
+		ret = FALSE;
+
+	return ret;
 }
 
 static u8 *serialize_message(u16 primType,
-    void *msg,
-    size_t *length,
-    u8 *buffer)
+	void *msg,
+	size_t *length,
+	u8 *buffer)
 {
-    CsrMsgConvPrimEntry *ptr;
-    u8 *ret;
-
-    ptr = CsrMsgConvFind(primType);
-
-    *length = 0;
-
-    if (ptr)
-    {
-        const CsrMsgConvMsgEntry *cv;
-
-        cv = find_msg_converter(ptr, *(u16 *) msg);
-        if (cv)
-        {
-            ret = cv->serFunc(buffer, length, msg);
-        }
-        else
-        {
-            ret = NULL;
-        }
-    }
-    else
-    {
-        ret = NULL;
-    }
-
-    return ret;
+	CsrMsgConvPrimEntry *ptr;
+	u8 *ret;
+
+	ptr = CsrMsgConvFind(primType);
+
+	*length = 0;
+
+	if (ptr) {
+		const CsrMsgConvMsgEntry *cv;
+
+		cv = find_msg_converter(ptr, *(u16 *) msg);
+		if (cv)
+			ret = cv->serFunc(buffer, length, msg);
+		else
+			ret = NULL;
+	} else
+		ret = NULL;
+
+	return ret;
 }
 
 size_t CsrMsgConvSizeof(u16 primType, void *msg)
 {
-    return sizeof_message(primType, msg);
+	return sizeof_message(primType, msg);
 }
 
-u8 *CsrMsgConvSerialize(u8 *buffer, size_t maxBufferOffset, size_t *offset, u16 primType, void *msg)
+u8 *CsrMsgConvSerialize(u8 *buffer, size_t maxBufferOffset,
+		size_t *offset, u16 primType, void *msg)
 {
-    if (converter)
-    {
-        size_t serializedLength;
-        u8 *bufSerialized;
-        u8 *bufOffset = &buffer[*offset];
-        bufSerialized = converter->serialize_message(primType, msg, &serializedLength, bufOffset);
-        *offset += serializedLength;
-        return bufSerialized;
-    }
-    else
-    {
-        return NULL;
-    }
+	if (converter) {
+		size_t serializedLength;
+		u8 *bufSerialized;
+		u8 *bufOffset = &buffer[*offset];
+		bufSerialized = converter->serialize_message(primType, msg,
+			&serializedLength, bufOffset);
+		*offset += serializedLength;
+		return bufSerialized;
+	} else
+		return NULL;
 }
 
 /* Insert profile converter at head of converter list. */
 void CsrMsgConvInsert(u16 primType, const CsrMsgConvMsgEntry *ce)
 {
-    CsrMsgConvPrimEntry *pc;
-    pc = CsrMsgConvFind(primType);
-
-    if (pc)
-    {
-        /* Already registered. Do nothing */
-    }
-    else
-    {
-        pc = kmalloc(sizeof(*pc), GFP_KERNEL);
-        pc->primType = primType;
-        pc->conv = ce;
-        pc->lookupFunc = NULL;
-        pc->next = converter->profile_converters;
-        converter->profile_converters = pc;
-    }
+	CsrMsgConvPrimEntry *pc;
+	pc = CsrMsgConvFind(primType);
+
+	if (pc) {
+		/* Already registered. Do nothing */
+	} else {
+		pc = kmalloc(sizeof(*pc), GFP_KERNEL);
+		pc->primType = primType;
+		pc->conv = ce;
+		pc->lookupFunc = NULL;
+		pc->next = converter->profile_converters;
+		converter->profile_converters = pc;
+	}
 }
 EXPORT_SYMBOL_GPL(CsrMsgConvInsert);
 
 CsrMsgConvMsgEntry *CsrMsgConvFindEntry(u16 primType, u16 msgType)
 {
-    CsrMsgConvPrimEntry *ptr = CsrMsgConvFind(primType);
-    if (ptr)
-    {
-        return (CsrMsgConvMsgEntry *) find_msg_converter(ptr, msgType);
-    }
-    return NULL;
+	CsrMsgConvPrimEntry *ptr = CsrMsgConvFind(primType);
+	if (ptr)
+		return (CsrMsgConvMsgEntry *) find_msg_converter(ptr, msgType);
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(CsrMsgConvFindEntry);
 
 CsrMsgConvMsgEntry *CsrMsgConvFindEntryByMsg(u16 primType, const void *msg)
 {
-    CsrMsgConvPrimEntry *ptr = CsrMsgConvFind(primType);
-    if (ptr && msg)
-    {
-        u16 msgType = *((u16 *) msg);
-        return (CsrMsgConvMsgEntry *) find_msg_converter(ptr, msgType);
-    }
-    return NULL;
+	CsrMsgConvPrimEntry *ptr = CsrMsgConvFind(primType);
+	if (ptr && msg) {
+		u16 msgType = *((u16 *) msg);
+		return (CsrMsgConvMsgEntry *) find_msg_converter(ptr, msgType);
+	}
+	return NULL;
 }
 
-void CsrMsgConvCustomLookupRegister(u16 primType, CsrMsgCustomLookupFunc *lookupFunc)
+void CsrMsgConvCustomLookupRegister(u16 primType,
+	CsrMsgCustomLookupFunc *lookupFunc)
 {
-    CsrMsgConvPrimEntry *ptr = CsrMsgConvFind(primType);
-    if (ptr)
-    {
-        ptr->lookupFunc = lookupFunc;
-    }
+	CsrMsgConvPrimEntry *ptr = CsrMsgConvFind(primType);
+	if (ptr)
+		ptr->lookupFunc = lookupFunc;
 }
 EXPORT_SYMBOL_GPL(CsrMsgConvCustomLookupRegister);
 
 CsrMsgConvEntry *CsrMsgConvInit(void)
 {
-    if (!converter)
-    {
-        converter = kmalloc(sizeof(CsrMsgConvEntry), GFP_KERNEL);
-
-        converter->profile_converters = NULL;
-        converter->free_message = free_message;
-        converter->sizeof_message = sizeof_message;
-        converter->serialize_message = serialize_message;
-        converter->deserialize_data = deserialize_data;
-    }
-
-    return converter;
+	if (!converter) {
+		converter = kmalloc(sizeof(CsrMsgConvEntry), GFP_KERNEL);
+		converter->profile_converters = NULL;
+		converter->free_message = free_message;
+		converter->sizeof_message = sizeof_message;
+		converter->serialize_message = serialize_message;
+		converter->deserialize_data = deserialize_data;
+	}
+
+	return converter;
 }
 EXPORT_SYMBOL_GPL(CsrMsgConvInit);
-- 
1.8.1.1


-- 
Jake Champlin
jake.champlin.27@gmail.com
<MuttClient>
