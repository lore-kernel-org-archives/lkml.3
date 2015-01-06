Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbbAFOdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:33:45 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59796 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbbAFOdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:33:43 -0500
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Evgeniy Polyakov <zbr@ioremap.net>, David Fries <David@Fries.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] w1: slaves: w1_therm: Add sysfs entry for current temperature
Date: Tue,  6 Jan 2015 15:29:54 +0100
Message-Id: <1420554596-10250-1-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DS18B20 and it's brothers are pretty popular in the RaspberryPi world
when it comes to temperature measurement. All tutorials on the Internet
use the same way of parsing the output of the w1_slave sysfs file.
These patches add a dedicated sysfs entry called 'temp' whose only job
is to output the current temperature.

What could be improved here is the way how dev->bus_mutex is locked/unlocked,
which is split right now between two functions - maybe it would be better
to move all dev->bus_mutex locking into read_rom() and introduce another
mutex for protecting the slave's structures (e.g. family_data).

Mariusz Gorski (2):
  w1: slaves: w1_therm: Extract read_rom function
  w1: slaves: w1_therm: Add temp attribute

 drivers/w1/slaves/w1_therm.c | 83 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 65 insertions(+), 18 deletions(-)

-- 
2.2.1

