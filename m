Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945955Ab3BGXKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 18:10:04 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62883 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab3BGXKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 18:10:02 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Subject: Re: [char-misc-next 05/11] mei: bus: Call bus routines from the core code
Date: Thu, 7 Feb 2013 23:09:58 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1360270997-7639-1-git-send-email-tomas.winkler@intel.com> <201302072237.31048.arnd@arndb.de> <5B8DA87D05A7694D9FA63FD143655C1B01EC3BB6@HASMSX106.ger.corp.intel.com>
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B01EC3BB6@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302072309.59009.arnd@arndb.de>
X-Provags-ID: V02:K0:rN7sJ4EdDRZrEOpUdk9By3aP+tzTLzEi/XFTw8sZ7/5
 QwLZt3K7Ca2f6fNpuMLglsFMNU2/KT8ObIN0cNDHhnW573rMOU
 GZbDml2wYTHei/eilzsvwONfRKHlM5Dzh1nsl49h+fNGns3+R/
 LmEpphOto45PLHHx6ahqvqU3nxfe3Bj+K+mOt8EX/x7xiFPTrZ
 mlXvDMycF4s0NZUUPCQT5UDWHkZTXQM891yS8pE0aWkxhd/JNd
 jiwXS5sGlRDrqhkGhFiMo4bc4imDnIdj2N6l0AUd8BOxPWYo6w
 V04lQpOCM/Tdz8PNxRZIUtpfdvi6ucKqmgdHjRJId6jaQh9ipx
 pG2I+5VxhUtPr4m4G2Hs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2013, Winkler, Tomas wrote:
> Second why to register anything if the MEI device is not present on the system. 

Mostly to match the expectations of readers of that code. Note that no memory
is wasted if you do this, because it's a static data structure. You can
actually save a few bytes because the registration call moves into an __init
section that is discarded after boot.

	Arnd
