Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbaAXLYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 06:24:21 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:58783 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaAXLYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 06:24:20 -0500
From: Marcus Folkesson <marcus.folkesson@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: iio: adis16400: Set timestamp as the last element in
Date: Fri, 24 Jan 2014 12:24:03 +0100
Message-Id: <1390562644-25124-1-git-send-email-marcus.folkesson@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <marcus.folkesson@gmail.com>
References: <marcus.folkesson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch make sure that the timestamp element is the last element
in the iio_chan_spec.
The index values for the timestamp was hardcoded and 
in conflict with other elements (at least on adis16448).

This is a problem in iio_compute_scan_bytes(). The function is 
searching for the first element with the timestamp index.
If the found element has a lesser number of storage bits, this
is a potential buffer overflow issue.


