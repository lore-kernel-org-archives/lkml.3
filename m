Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab3GQB5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 21:57:55 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:43817 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab3GQB5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 21:57:53 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 16 Jul 2013 18:57:32 -0700
Message-ID: <CALCETrUKK2j17LP+dVe61UCj05w914RRgyGXhorP1nfS7=rKnA@mail.gmail.com>
Subject: What endianness is word in i2c_smbus_data?
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm rather confused here.  In SMBUS, the "read word" operation returns
two bytes.  Just to be confusing, the SMBUS spec calls the first byte
"Data Byte Low" and the second byte "Data Byte High".  But they really
are the first and second bytes -- Read Word will return whatever Read
Byte would have as its first byte.  Let's call these bytes B1 and B2
for first and second.

The eeprom and at24 drivers expect data->word to be (B2 << 8) | B1.
That is, data->word is the cpu representation of the value on the bus
if that value is treated as little-endian.  Is that indeed the correct
interpretation?  If so, should it be documented somewhere?

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
