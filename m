Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbaCKWUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 18:20:04 -0400
Received: from [172.245.23.124] ([172.245.23.124]:57674 "EHLO
	w1-ca.frizzlehost.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755841AbaCKWT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 18:19:59 -0400
From: Fred Akers <knivey@botops.net>
To: gregkh@linuxfoundation.org, abbotti@mev.co.uk,
        hsweeten@visionengravers.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fred Akers <knivey@botops.net>
Subject: [PATCH v3 2/2] Staging: Comedi: addi-data: Clean up function comments
Date: Tue, 11 Mar 2014 18:19:13 -0400
Message-Id: <1394576353-25247-2-git-send-email-knivey@botops.net>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394350009-23464-1-git-send-email-knivey@botops.net>
References: <1394350009-23464-1-git-send-email-knivey@botops.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These comments look terrible and are full of redundant information.
Also reformat the license at the head of the file to wrap at 80 char.

Signed-off-by: Fred Akers <knivey@botops.net>
---
Sorry, I was not able to reorder thess commits :-(
---
 .../comedi/drivers/addi-data/hwdrv_apci035.c       | 292 ++++---------
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      | 463 ++++-----------------
 .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 269 +++---------
 3 files changed, 213 insertions(+), 811 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
index 2c9fe1f..28450f6 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
@@ -1,46 +1,24 @@
-/**
-@verbatim
-
-Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
-
-	ADDI-DATA GmbH
-	Dieselstrasse 3
-	D-77833 Ottersweier
-	Tel: +19(0)7223/9493-0
-	Fax: +49(0)7223/9493-92
-	http://www.addi-data.com
-	info@addi-data.com
-
-This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
-
-This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
-
-@endverbatim
-*/
 /*
-
-  +-----------------------------------------------------------------------+
-  | (C) ADDI-DATA GmbH          Dieselstraße 3       D-77833 Ottersweier  |
-  +-----------------------------------------------------------------------+
-  | Tel : +49 (0) 7223/9493-0     | email    : info@addi-data.com         |
-  | Fax : +49 (0) 7223/9493-92    | Internet : http://www.addi-data.com   |
-  +-------------------------------+---------------------------------------+
-  | Project     : APCI-035        | Compiler   : GCC                      |
-  | Module name : hwdrv_apci035.c | Version    : 2.96                     |
-  +-------------------------------+---------------------------------------+
-  | Project manager: Eric Stolz   | Date       :  02/12/2002              |
-  +-------------------------------+---------------------------------------+
-  | Description :   Hardware Layer Access For APCI-035                    |
-  +-----------------------------------------------------------------------+
-  |                             UPDATES                                   |
-  +----------+-----------+------------------------------------------------+
-  |   Date   |   Author  |          Description of updates                |
-  +----------+-----------+------------------------------------------------+
-  |          |           |                                                |
-  |          |           |                                                |
-  |          |           |                                                |
-  +----------+-----------+------------------------------------------------+
-*/
+ * Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
+ *
+ *	ADDI-DATA GmbH
+ *	Dieselstrasse 3
+ *	D-77833 Ottersweier
+ *	Tel: +19(0)7223/9493-0
+ *	Fax: +49(0)7223/9493-92
+ *	http://www.addi-data.com
+ *	info@addi-data.com
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License as published by the Free Software
+ * Foundation; either version 2 of the License, or (at your option) any later
+ * version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
+ * details.
+ */
 
 /* Card Specific information */
 #define APCI035_ADDRESS_RANGE		255
@@ -109,60 +87,32 @@ static struct comedi_lrange range_apci035_ai = {
 static int i_WatchdogNbr;
 static int i_Temp;
 static int i_Flag = 1;
+
 /*
-+----------------------------------------------------------------------------+
-| Function   Name   : int apci035_timer_config                      |
-|			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
-|                      struct comedi_insn *insn,unsigned int *data)                     |
-+----------------------------------------------------------------------------+
-| Task              : Configures The Timer , Counter or Watchdog             |
-+----------------------------------------------------------------------------+
-| Input Parameters  : struct comedi_device *dev : Driver handle                     |
-|                     unsigned int *data         : Data Pointer contains             |
-|                                          configuration parameters as below |
-|                                                                            |
-|					  data[0]            : 0 Configure As Timer      |
-|										   1 Configure As Watchdog   |
-|                                         data[1]            : Watchdog number
-|					  data[2]            : Time base Unit            |
-|					  data[3]			 : Reload Value			     |
-|                                         data[4]            : External Trigger          |
-|                                                              1:Enable
-|                                                           0:Disable
-|                              data[5]            :External Trigger Level
-|                                                  00 Trigger Disabled
-|                                                  01 Trigger Enabled (Low level)
-|                                                  10 Trigger Enabled (High Level)
-|                                                  11 Trigger Enabled (High/Low level)
-|                              data[6]            : External Gate            |
-|                                                   1:Enable
-|                                                   0:Disable
-|                              data[7]            : External Gate level
-|                                                  00 Gate Disabled
-|                                                  01 Gate Enabled (Low level)
-|                                                  10 Gate Enabled (High Level)
-|                              data[8]            :Warning Relay
-|                                                  1: ENABLE
-|                                                  0: DISABLE
-|                              data[9]            :Warning Delay available
-|                              data[10]           :Warning Relay Time unit
-|                              data[11]           :Warning Relay Time Reload value
-|                              data[12]           :Reset Relay
-|                                                  1 : ENABLE
-|                                                  0 : DISABLE
-|                              data[13]           :Interrupt
-|                                                  1 : ENABLE
-|                                                  0 : DISABLE
-|
-|
-+----------------------------------------------------------------------------+
-| Output Parameters :	--													 |
-+----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error          |
-|			                                                         |
-+----------------------------------------------------------------------------+
-*/
+ * Configures The Timer , Counter or Watchdog
+ *
+ * data[0] 0 = Configure As Timer, 1 = Configure As Watchdog
+ * data[1] Watchdog number
+ * data[2] Time base Unit
+ * data[3] Reload Value
+ * data[4] External Trigger, 1 = Enable, 0 = Disable
+ * data[5] External Trigger Level
+ *	00 = Trigger Disabled
+ *	01 = Trigger Enabled (Low level)
+ *	10 = Trigger Enabled (High Level)
+ *	11 = Trigger Enabled (High/Low level)
+ * data[6] External Gate, 1 = Enable, 0 = Disable
+ * data[7] External Gate level
+ *	00 = Gate Disabled
+ *	01 = Gate Enabled (Low level)
+ *	10 = Gate Enabled (High Level)
+ * data[8] Warning Relay, 1 = Enable, 0 = Disable
+ * data[9] Warning Delay available
+ * data[10] Warning Relay Time unit
+ * data[11] Warning Relay Time Reload value
+ * data[12] Reset Relay, 1 = Enable, 0 = Disable
+ * data[13] Interrupt, 1 = Enable, 0 = Disable
+ */
 static int apci035_timer_config(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn,
@@ -286,32 +236,16 @@ static int apci035_timer_config(struct comedi_device *dev,
 }
 
 /*
-+----------------------------------------------------------------------------+
-| Function   Name   : int apci035_timer_write              |
-|			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
-|                      struct comedi_insn *insn,unsigned int *data)                     |
-+----------------------------------------------------------------------------+
-| Task              : Start / Stop The Selected Timer , or Watchdog  |
-+----------------------------------------------------------------------------+
-| Input Parameters  : struct comedi_device *dev : Driver handle                     |
-|                     unsigned int *data         : Data Pointer contains             |
-|                                          configuration parameters as below |
-|					                                                 |
-|					  data[0] : 0 - Stop Selected Timer/Watchdog     |
-|					            1 - Start Selected Timer/Watchdog    |
-|					            2 - Trigger Selected Timer/Watchdog  |
-|					            3 - Stop All Timer/Watchdog          |
-|					            4 - Start All Timer/Watchdog         |
-|					            5 - Trigger All Timer/Watchdog       |
-|					                                                 |
-+----------------------------------------------------------------------------+
-| Output Parameters :	--													 |
-+----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error			 |
-|					                                                 |
-+----------------------------------------------------------------------------+
-*/
+ * Start / Stop The Selected Timer , or Watchdog
+ *
+ * data[0]
+ *	0 - Stop Selected Timer/Watchdog
+ *	1 - Start Selected Timer/Watch*dog
+ *	2 - Trigger Selected Timer/Watchdog
+ *	3 - Stop All Timer/Watchdog
+ *	4 - Start All Timer/Watchdog
+ *	5 - Trigger All Timer/Watchdog
+ */
 static int apci035_timer_write(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn,
@@ -401,32 +335,14 @@ static int apci035_timer_write(struct comedi_device *dev,
 }
 
 /*
-+----------------------------------------------------------------------------+
-| Function   Name   : int apci035_timer_read                        |
-|			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
-|                      struct comedi_insn *insn,unsigned int *data)                     |
-+----------------------------------------------------------------------------+
-| Task              : Read The Selected Timer , Counter or Watchdog          |
-+----------------------------------------------------------------------------+
-| Input Parameters  : struct comedi_device *dev : Driver handle                     |
-|                     unsigned int *data         : Data Pointer contains             |
-|                                          configuration parameters as below |
-|                                                                            |
-|     																	 |
-+----------------------------------------------------------------------------+
-| Output Parameters :	data[0]            : software trigger status
-|                       data[1]            : hardware trigger status
-|     	  	        data[2]            : Software clear status
-|                       data[3]            : Overflow status
-|                       data[4]            : Timer actual value
-|
-
-+----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error          |
-|			                                                         |
-+----------------------------------------------------------------------------+
-*/
+ * Read The Selected Timer , Counter or Watchdog
+ *
+ * data[0] software trigger status
+ * data[1] hardware trigger status
+ * data[2] Software clear status
+ * data[3] Overflow status
+ * data[4] Timer actual value
+ */
 static int apci035_timer_read(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn,
@@ -458,28 +374,10 @@ static int apci035_timer_read(struct comedi_device *dev,
 }
 
 /*
-+----------------------------------------------------------------------------+
-| Function   Name   : int apci035_ai_config                        |
-|			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
-|                      struct comedi_insn *insn,unsigned int *data)                     |
-+----------------------------------------------------------------------------+
-| Task              : Configures The Analog Input Subdevice                  |
-+----------------------------------------------------------------------------+
-| Input Parameters  : struct comedi_device *dev      : Driver handle                |
-|                     struct comedi_subdevice *s     : Subdevice Pointer            |
-|                     struct comedi_insn *insn       : Insn Structure Pointer       |
-|                     unsigned int *data          : Data Pointer contains        |
-|                                          configuration parameters as below |
-|                     data[0]                  : Warning delay value
-|                                                                            |
-+----------------------------------------------------------------------------+
-| Output Parameters :	--													 |
-+----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error          |
-|			                                                         |
-+----------------------------------------------------------------------------+
-*/
+ * Configures The Analog Input Subdevice
+ *
+ * data[0] Warning delay value
+ */
 static int apci035_ai_config(struct comedi_device *dev,
 			     struct comedi_subdevice *s,
 			     struct comedi_insn *insn,
@@ -500,26 +398,10 @@ static int apci035_ai_config(struct comedi_device *dev,
 }
 
 /*
-+----------------------------------------------------------------------------+
-| Function   Name   : int apci035_ai_read                          |
-|			          (struct comedi_device *dev,struct comedi_subdevice *s,       |
-|                     struct comedi_insn *insn,unsigned int *data)                      |
-+----------------------------------------------------------------------------+
-| Task              : Read  value  of the selected channel			         |
-+----------------------------------------------------------------------------+
-| Input Parameters  : struct comedi_device *dev      : Driver handle                |
-|                     unsigned int ui_NoOfChannels    : No Of Channels To read       |
-|                     unsigned int *data              : Data Pointer to read status  |
-+----------------------------------------------------------------------------+
-| Output Parameters :	--													 |
-|			          data[0]  : Digital Value Of Input              |
-|			                                                         |
-+----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error          |
-|			                                                         |
-+----------------------------------------------------------------------------+
-*/
+ * Read value of the selected channel
+ *
+ * data[0] Digital Value Of Input
+ */
 static int apci035_ai_read(struct comedi_device *dev,
 			   struct comedi_subdevice *s,
 			   struct comedi_insn *insn,
@@ -539,21 +421,6 @@ static int apci035_ai_read(struct comedi_device *dev,
 	return insn->n;
 }
 
-/*
-+----------------------------------------------------------------------------+
-| Function   Name   :  int apci035_reset(struct comedi_device *dev)
-|					                                                         |
-+----------------------------------------------------------------------------+
-| Task              :Resets the registers of the card                        |
-+----------------------------------------------------------------------------+
-| Input Parameters  :                                                        |
-+----------------------------------------------------------------------------+
-| Output Parameters :	--													 |
-+----------------------------------------------------------------------------+
-| Return Value      :                                                        |
-|			                                                                 |
-+----------------------------------------------------------------------------+
-*/
 static int apci035_reset(struct comedi_device *dev)
 {
 	struct addi_private *devpriv = dev->private;
@@ -570,23 +437,6 @@ static int apci035_reset(struct comedi_device *dev)
 	return 0;
 }
 
-/*
-+----------------------------------------------------------------------------+
-| Function   Name   : static void apci035_interrupt
-|					  (int irq , void *d)      |
-+----------------------------------------------------------------------------+
-| Task              : Interrupt processing Routine                           |
-+----------------------------------------------------------------------------+
-| Input Parameters  : int irq                 : irq number                   |
-|                     void *d                 : void pointer                 |
-+----------------------------------------------------------------------------+
-| Output Parameters :	--													 |
-+----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error          |
-|			                                                         |
-+----------------------------------------------------------------------------+
-*/
 static void apci035_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
index ab4e4c9..a633957 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
@@ -1,48 +1,25 @@
-/**
-@verbatim
-
-Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
-
-	ADDI-DATA GmbH
-	Dieselstrasse 3
-	D-77833 Ottersweier
-	Tel: +19(0)7223/9493-0
-	Fax: +49(0)7223/9493-92
-	http://www.addi-data.com
-	info@addi-data.com
-
-This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
-
-This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
-
-@endverbatim
-*/
 /*
-
-  +-----------------------------------------------------------------------+
-  | (C) ADDI-DATA GmbH          Dieselstraße 3       D-77833 Ottersweier  |
-  +-----------------------------------------------------------------------+
-  | Tel : +49 (0) 7223/9493-0     | email    : info@addi-data.com         |
-  | Fax : +49 (0) 7223/9493-92    | Internet : http://www.addi-data.com   |
-  +-------------------------------+---------------------------------------+
-  | Project     : APCI-1500       | Compiler   : GCC                      |
-  | Module name : hwdrv_apci1500.c| Version    : 2.96                     |
-  +-------------------------------+---------------------------------------+
-  | Project manager: Eric Stolz   | Date       :  02/12/2002              |
-  +-------------------------------+---------------------------------------+
-  | Description :   Hardware Layer Access For APCI-1500                   |
-  +-----------------------------------------------------------------------+
-  |                             UPDATES                                   |
-  +----------+-----------+------------------------------------------------+
-  |   Date   |   Author  |          Description of updates                |
-  +----------+-----------+------------------------------------------------+
-  |          |           |                                                |
-  |          |           |                                                |
-  |          |           |                                                |
-  +----------+-----------+------------------------------------------------+
-*/
-
-/*********      Definitions for APCI-1500 card  *****/
+ * Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
+ *
+ *	ADDI-DATA GmbH
+ *	Dieselstrasse 3
+ *	D-77833 Ottersweier
+ *	Tel: +19(0)7223/9493-0
+ *	Fax: +49(0)7223/9493-92
+ *	http://www.addi-data.com
+ *	info@addi-data.com
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License as published by the Free Software
+ * Foundation; either version 2 of the License, or (at your option) any later
+ * version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
+ * details.
+ *
+ */
 
 /* Card Specific information */
 #define APCI1500_ADDRESS_RANGE		4
@@ -153,83 +130,29 @@ static int i_TimerCounter1Enabled, i_TimerCounter2Enabled,
 	   i_WatchdogCounter3Enabled;
 
 /*
-  +----------------------------------------------------------------------------+
-  | Function   Name   : int apci1500_di_config                 |
-|			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
-|                      struct comedi_insn *insn,unsigned int *data)                     |
-+----------------------------------------------------------------------------+
-| Task              : An event can be generated for each port.               |
-|                     The first event is related to the first 8 channels     |
-|                     (port 1) and the second to the following 6 channels    |
-|                     (port 2). An interrupt is generated when one or both   |
-|                     events have occurred                                   |
-+----------------------------------------------------------------------------+
-| Input Parameters  : struct comedi_device *dev : Driver handle                     |
-|                     unsigned int *data     : Data Pointer contains             |
-|                                          configuration parameters as below |
-|                                                                            |
-|			  data[0]            :Number of the input port on        |
-|                                         which the event will take place    |
-|                                         (1 or 2)
-|                      data[1]            : The event logic for port 1 has    |
-|                                            three possibilities             |
-|                                        :0  APCI1500_AND       :This logic  |
-|                                                                links       |
-|                                                                the inputs  |
-|                                                                with an AND |
-|                                                                logic.      |
-|                                          1 APCI1500_OR        :This logic  |
-|                                                                links       |
-|                                                                the inputs  |
-|                                                                with a      |
-|                                                                OR logic.   |
-|                                          2    APCI1500_OR_PRIORITY        |
-|								:This logic                          |
-|                                                                links       |
-|                                                                the inputs  |
-|                                                                with a      |
-|                                                                priority    |
-|                                                                OR logic.   |
-|                                                                Input 1     |
-|                                                                has the     |
-|                                                                highest     |
-|                                                                priority    |
-|                                                                level and   |
-|                                                                input   8   |
-|                                                                the smallest|
-|                                            For the second port the user has|
-|                                            1 possibility:                  |
-|                                            APCI1500_OR        :This logic  |
-|                                                                links       |
-|                                                                the inputs  |
-|                                                                with a      |
-|                                                                polarity    |
-|                                                                OR logic    |
-|                     data[2]              : These 8-character word for port1|
-|                                            and 6-character word for port 2 |
-|                                            give the mask of the event.     |
-|                                            Each place gives the state      |
-|                                            of the input channels and can   |
-|                                            have one of these six characters|
-|                                                     |
-|                                       0  : This input must be on 0         |
-|                                       1  : This input must be on 1         |
-|                                       2  : This input reacts to            |
-|                                            a falling edge                  |
-|                                       3  : This input reacts to a          |
-|                                            rising edge                     |
-|                                       4  : This input reacts to both edges |
-|
-|								5  : This input is not               |
-|                                            used for event   				 |
-+----------------------------------------------------------------------------+
-| Output Parameters :	--													 |
-+----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error          |
-|			                                                         |
-+----------------------------------------------------------------------------+
-*/
+ * An event can be generated for each port. The first event is related to the
+ * first 8 channels (port 1) and the second to the following 6 channels (port 2)
+ * An interrupt is generated when one or both events have occurred.
+ *
+ * data[0] Number of the input port on which the event will take place (1 or 2)
+ * data[1] The event logic for port 1 has three possibilities:
+ *	APCI1500_AND		This logic links the inputs with an AND logic.
+ *	APCI1500_OR		This logic links the inputs with a OR logic.
+ *	APCI1500_OR_PRIORITY	This logic links the inputs with a priority OR
+ *				logic. Input 1 has the highest priority level
+ *				and input 8 the	smallest.
+ *	For the second port the user has 1 possibility:
+ *	APCI1500_OR	This logic links the inputs with a polarity OR logic
+ * data[2] These 8-character word for port1 and 6-character word for port 2
+ *	   give the mask of the event. Each place gives the state of the input
+ *	   channels and can have one of these six characters
+ *	0 This input must be on 0
+ *	1 This input must be on 1
+ *	2 This input reacts to a falling edge
+ *	3 This input reacts to a rising edge
+ *	4 This input reacts to both edges
+ *	5 This input is not used for event
+ */
 static int apci1500_di_config(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn,
@@ -537,27 +460,11 @@ static int apci1500_di_config(struct comedi_device *dev,
 }
 
 /*
-+----------------------------------------------------------------------------+
-| Function   Name   : int apci1500_di_write                     |
-|			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
-|                      struct comedi_insn *insn,unsigned int *data)                     |
-+----------------------------------------------------------------------------+
-| Task              :  Allows or disallows a port event                      |
-+----------------------------------------------------------------------------+
-| Input Parameters  : struct comedi_device *dev      : Driver handle                |
-|		              unsigned int ui_Channel : Channel number to read       |
-|                     unsigned int *data          : Data Pointer to read status  |
-|                      data[0]                 :0 Start input event
-|                                               1 Stop input event
-|                      data[1]                 :No of port (1 or 2)
-+----------------------------------------------------------------------------+
-| Output Parameters :	--													 |
-+----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error          |
-|			                                                         |
-+----------------------------------------------------------------------------+
-*/
+ * Allows or disallows a port event
+ *
+ * data[0] 0 = Start input event, 1 = Stop input event
+ * data[1] Number of port (1 or 2)
+ */
 static int apci1500_di_write(struct comedi_device *dev,
 			     struct comedi_subdevice *s,
 			     struct comedi_insn *insn,
@@ -748,24 +655,8 @@ static int apci1500_di_write(struct comedi_device *dev,
 }
 
 /*
-+----------------------------------------------------------------------------+
-| Function   Name   : int apci1500_di_read                          |
-|			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
-|                      struct comedi_insn *insn,unsigned int *data)                     |
-+----------------------------------------------------------------------------+
-| Task              : Return the status of the digital input                 |
-+----------------------------------------------------------------------------+
-| Input Parameters  : struct comedi_device *dev      : Driver handle                |
-|		              unsigned int ui_Channel : Channel number to read       |
-|                     unsigned int *data          : Data Pointer to read status  |
-+----------------------------------------------------------------------------+
-| Output Parameters :	--													 |
-+----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error          |
-|			                                                         |
-+----------------------------------------------------------------------------+
-*/
+ * Return the status of the digital input
+ */
 static int apci1500_di_read(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn,
@@ -915,33 +806,11 @@ static int apci1500_di_insn_bits(struct comedi_device *dev,
 }
 
 /*
-+----------------------------------------------------------------------------+
-| Function   Name   : int apci1500_do_config
-|                      (struct comedi_device *dev,struct comedi_subdevice *s struct comedi_insn
-|                      *insn,unsigned int *data)                                  |
-|				                                                     |
-+----------------------------------------------------------------------------+
-| Task              : Configures the digital output memory and the digital
-|                      output error interrupt                                 |
-+----------------------------------------------------------------------------+
-| Input Parameters  : struct comedi_device *dev : Driver handle                     |
-|                     unsigned int *data         : Data Pointer contains         |
-|                                          configuration parameters as below |
-|                      struct comedi_subdevice *s,   :pointer to subdevice structure
-|                       struct comedi_insn *insn      :pointer to insn structure                                                                                                                |
-|					  data[0]  :1:Memory on                          |
-|					            0:Memory off                         |
-|                              data[1]  :1 Enable the voltage error interrupt
-|							   :0 Disable the voltage error interrupt 		                                                                                                    |
-|																	 |
-+----------------------------------------------------------------------------+
-| Output Parameters :	--													 |
-+----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error          |
-|			                                                         |
-+----------------------------------------------------------------------------+
-*/
+ * Configures the digital output memory and the digital output error interrupt
+ *
+ * data[1] 1 = Enable the voltage error interrupt
+ *	   2 = Disable the voltage error interrupt
+ */
 static int apci1500_do_config(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn,
@@ -954,24 +823,8 @@ static int apci1500_do_config(struct comedi_device *dev,
 }
 
 /*
-+----------------------------------------------------------------------------+
-| Function   Name   : int apci1500_do_write                      |
-|			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
-|                      struct comedi_insn *insn,unsigned int *data)                     |
-+----------------------------------------------------------------------------+
-| Task              : Writes port value  To the selected port                |
-+----------------------------------------------------------------------------+
-| Input Parameters  : struct comedi_device *dev      : Driver handle                |
-|                     unsigned int ui_NoOfChannels    : No Of Channels To Write      |
-|                     unsigned int *data              : Data Pointer to read status  |
-+----------------------------------------------------------------------------+
-| Output Parameters :	--													 |
-+----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error          |
-|			                                                         |
-+----------------------------------------------------------------------------+
-*/
+ * Writes port value to the selected port
+ */
 static int apci1500_do_write(struct comedi_device *dev,
 			     struct comedi_subdevice *s,
 			     struct comedi_insn *insn,
@@ -1125,53 +978,19 @@ static int apci1500_do_write(struct comedi_device *dev,
 }
 
 /*
-+----------------------------------------------------------------------------+
-| Function   Name   : int apci1500_timer_config(comedi_device
-|                   *dev,struct comedi_subdevice *s,struct comedi_insn *insn,unsigned int *data)|
-|				                                                     |
-+----------------------------------------------------------------------------+
-| Task              : Configures The Watchdog                                |
-+----------------------------------------------------------------------------+
-| Input Parameters  : struct comedi_device *dev      : Driver handle                |
-|                     struct comedi_subdevice *s,   :pointer to subdevice structure
-|                      struct comedi_insn *insn      :pointer to insn structure      |
-|                     unsigned int *data         : Data Pointer to read status                                                       data[0]                : 2     APCI1500_1_8_KHZ
-|                                              1     APCI1500_3_6_KHZ        |
-|                                              0     APCI1500_115_KHZ
-|                      data[1]                : 0     Counter1/Timer1
-|                                               1     Counter2/Timer2
-|                                               2     Counter3/Watchdog
-|                      data[2]                : 0     Counter
-|                                               1     Timer/Watchdog
-|                      data[3]                :         This parameter has    |
-|                                                      two meanings.         |
-|                                                    - If the counter/timer  |
-|                                                      is used as a counter  |
-|                                                      the limit value of    |
-|                                                      the counter is given  |
-|                                                                            |
-|                                                    - If the counter/timer  |
-|                                                      is used as a timer,   |
-|                                                      the divider factor    |
-|                                                      for the output is     |
-|                                                      given.
-|                       data[4]                 : 0    APCI1500_CONTINUOUS
-|                                                 1    APCI1500_SINGLE
-|                       data[5]                 : 0    Software Trigger
-|                                                 1    Hardware Trigger
-|
-|                       data[6]                  :0    Software gate
-|                                                 1    Hardware gate
-|                       data[7]                  :0    Interrupt Disable
-|                                                 1    Interrupt Enable
-+----------------------------------------------------------------------------+
-| Output Parameters :	--													 |
-+----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error          |
-|			                                                         |
-+----------------------------------------------------------------------------+
-*/
+ * Configures The Watchdog
+ *
+ * data[0] 0 = APCI1500_115_KHZ, 1 = APCI1500_3_6_KHZ, 2 = APCI1500_1_8_KHZ
+ * data[1] 0 = Counter1/Timer1, 1 =  Counter2/Timer2, 2 = Counter3/Watchdog
+ * data[2] 0 = Counter, 1 = Timer/Watchdog
+ * data[3] This parameter has two meanings. If the counter/timer is used as
+ *	a counter the limit value of the counter is given. If the counter/timer
+ *	is used as a timer, the divider factor for the output is given.
+ * data[4] 0 = APCI1500_CONTINUOUS, 1 = APCI1500_SINGLE
+ * data[5] 0 = Software Trigger, 1 = Hardware Trigger
+ * data[6] 0 = Software gate, 1 = Hardware gate
+ * data[7] 0 = Interrupt Disable, 1 = Interrupt Enable
+ */
 static int apci1500_timer_config(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn,
@@ -1663,33 +1482,12 @@ static int apci1500_timer_config(struct comedi_device *dev,
 }
 
 /*
-+----------------------------------------------------------------------------+
-| Function   Name   : int apci1500_timer_write
-|				(struct comedi_device *dev,struct comedi_subdevice *s,
-|                         struct comedi_insn *insn,unsigned int *data);                  |
-+----------------------------------------------------------------------------+
-| Task              : Start / Stop or trigger the timer counter or Watchdog  |
-+----------------------------------------------------------------------------+
-| Input Parameters  : struct comedi_device *dev     : Driver handle                 |
-|                     struct comedi_subdevice *s,   :pointer to subdevice structure
-|                      struct comedi_insn *insn      :pointer to insn structure      |
-|                     unsigned int *data         : Data Pointer to read status   |
-|                      data[0]                : 0     Counter1/Timer1
-|                                               1     Counter2/Timer2
-|                                               2     Counter3/Watchdog
-|                      data[1]                : 0     start
-|                                               1     stop
-|                                               2     Trigger
-|                      data[2]                : 0     Counter
-|                                               1     Timer/Watchdog
-+----------------------------------------------------------------------------+
-| Output Parameters :	--													 |
-+----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error          |
-|			                                                         |
-+----------------------------------------------------------------------------+
-*/
+ * Start / Stop or trigger the timer counter or Watchdog
+ *
+ * data[0] 0 = Counter1/Timer1, 1 =  Counter2/Timer2, 2 = Counter3/Watchdog
+ * data[1] 0 = Start, 1 = Stop, 2 = Trigger
+ * data[2] 0 = Counter, 1 = Timer/Watchdog
+ */
 static int apci1500_timer_write(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn,
@@ -1959,29 +1757,10 @@ static int apci1500_timer_write(struct comedi_device *dev,
 }
 
 /*
-+----------------------------------------------------------------------------+
-| Function   Name   : int apci1500_timer_bits                |
-|			(struct comedi_device *dev,struct comedi_subdevice *s,struct comedi_insn *insn,
-|                    unsigned int *data); 	                                     |
-+----------------------------------------------------------------------------+
-| Task              : Read The Watchdog                                      |
-+----------------------------------------------------------------------------+
-| Input Parameters  :   struct comedi_device *dev      : Driver handle              |
-|                     struct comedi_subdevice *s,   :pointer to subdevice structure
-|                      struct comedi_insn *insn      :pointer to insn structure      |
-|                     unsigned int *data          : Data Pointer to read status  |
-|                      data[0]                : 0     Counter1/Timer1
-|                                               1     Counter2/Timer2
-|                                               2     Counter3/Watchdog
-|
-+----------------------------------------------------------------------------+
-| Output Parameters :	--													 |
-+----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error          |
-|			                                                         |
-+----------------------------------------------------------------------------+
-*/
+ * Read The Watchdog
+ *
+ * data[0] 0 = Counter1/Timer1, 1 =  Counter2/Timer2, 2 = Counter3/Watchdog
+ */
 static int apci1500_timer_bits(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn,
@@ -2133,27 +1912,11 @@ static int apci1500_timer_bits(struct comedi_device *dev,
 }
 
 /*
-+----------------------------------------------------------------------------+
-| Function   Name   : int  apci1500_timer_read                      |
-|			(struct comedi_device *dev,struct comedi_subdevice *s,struct comedi_insn *insn,
-|                    unsigned int *data); 	                                     |
-+----------------------------------------------------------------------------+
-| Task              : Read the interrupt mask                                |
-+----------------------------------------------------------------------------+
-| Input Parameters  :   struct comedi_device *dev      : Driver handle              |
-|                     struct comedi_subdevice *s,   :pointer to subdevice structure
-|                      struct comedi_insn *insn      :pointer to insn structure      |
-|                     unsigned int *data          : Data Pointer to read status  |
-
-
-+----------------------------------------------------------------------------+
-| Output Parameters :	--	data[0]:The interrupt mask value												                           data[1]:Channel no
-+----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error          |
-|			                                                         |
-+----------------------------------------------------------------------------+
-*/
+ * Read the interrupt mask
+ *
+ * data[0] The interrupt mask value
+ * data[1] Channel Number
+ */
 static int apci1500_timer_read(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn,
@@ -2166,27 +1929,8 @@ static int apci1500_timer_read(struct comedi_device *dev,
 }
 
 /*
-+----------------------------------------------------------------------------+
-| Function   Name   : int  apci1500_do_bits                     |
-|			(struct comedi_device *dev,struct comedi_subdevice *s,struct comedi_insn *insn,
-|                    unsigned int *data); 	                                     |
-+----------------------------------------------------------------------------+
-| Task              : Configures the interrupt registers                     |
-+----------------------------------------------------------------------------+
-| Input Parameters  :   struct comedi_device *dev      : Driver handle              |
-|                     struct comedi_subdevice *s,   :pointer to subdevice structure
-|                      struct comedi_insn *insn      :pointer to insn structure      |
-|                     unsigned int *data          : Data Pointer                 |
-|
-
-+----------------------------------------------------------------------------+
-| Output Parameters :	--
-+----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error          |
-|			                                                         |
-+----------------------------------------------------------------------------+
-*/
+ * Configures the interrupt registers
+ */
 static int apci1500_do_bits(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn,
@@ -2310,23 +2054,6 @@ static int apci1500_do_bits(struct comedi_device *dev,
 	return insn->n;
 }
 
-/*
-+----------------------------------------------------------------------------+
-| Function   Name   : static void apci1500_interrupt
-|					  (int irq , void *d)      |
-+----------------------------------------------------------------------------+
-| Task              : Interrupt handler                                      |
-+----------------------------------------------------------------------------+
-| Input Parameters  : int irq                 : irq number                   |
-|                     void *d                 : void pointer                 |
-+----------------------------------------------------------------------------+
-| Output Parameters :	--													 |
-+----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error          |
-|			                                                         |
-+----------------------------------------------------------------------------+
-*/
 static void apci1500_interrupt(int irq, void *d)
 {
 
@@ -2505,20 +2232,6 @@ static void apci1500_interrupt(int irq, void *d)
 	return;
 }
 
-/*
-+----------------------------------------------------------------------------+
-| Function   Name   : int apci1500_reset(struct comedi_device *dev)
-+----------------------------------------------------------------------------+
-| Task              :resets all the registers                                |
-+----------------------------------------------------------------------------+
-| Input Parameters  : struct comedi_device *dev
-+----------------------------------------------------------------------------+
-| Output Parameters :	--													 |
-+----------------------------------------------------------------------------+
-| Return Value      :                                                        |
-|			                                                         |
-+----------------------------------------------------------------------------+
-*/
 static int apci1500_reset(struct comedi_device *dev)
 {
 	struct addi_private *devpriv = dev->private;
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
index c813abf..bcc5a05 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
@@ -1,48 +1,25 @@
-/**
-@verbatim
-
-Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
-
-	ADDI-DATA GmbH
-	Dieselstrasse 3
-	D-77833 Ottersweier
-	Tel: +19(0)7223/9493-0
-	Fax: +49(0)7223/9493-92
-	http://www.addi-data.com
-	info@addi-data.com
-
-This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
-
-This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
-
-@endverbatim
-*/
 /*
-
-  +-----------------------------------------------------------------------+
-  | (C) ADDI-DATA GmbH          Dieselstraße 3       D-77833 Ottersweier  |
-  +-----------------------------------------------------------------------+
-  | Tel : +49 (0) 7223/9493-0     | email    : info@addi-data.com         |
-  | Fax : +49 (0) 7223/9493-92    | Internet : http://www.addi-data.com   |
-  +-------------------------------+---------------------------------------+
-  | Project     : APCI-1564       | Compiler   : GCC                      |
-  | Module name : hwdrv_apci1564.c| Version    : 2.96                     |
-  +-------------------------------+---------------------------------------+
-  | Project manager: Eric Stolz   | Date       :  02/12/2002              |
-  +-------------------------------+---------------------------------------+
-  | Description :   Hardware Layer Access For APCI-1564                   |
-  +-----------------------------------------------------------------------+
-  |                             UPDATES                                   |
-  +----------+-----------+------------------------------------------------+
-  |   Date   |   Author  |          Description of updates                |
-  +----------+-----------+------------------------------------------------+
-  |          |           |                                                |
-  |          |           |                                                |
-  |          |           |                                                |
-  +----------+-----------+------------------------------------------------+
-*/
-
-/*********      Definitions for APCI-1564 card  *****/
+ * Copyright (C) 2004,2005  ADDI-DATA GmbH for the source code of this module.
+ *
+ *	ADDI-DATA GmbH
+ *	Dieselstrasse 3
+ *	D-77833 Ottersweier
+ *	Tel: +19(0)7223/9493-0
+ *	Fax: +49(0)7223/9493-92
+ *	http://www.addi-data.com
+ *	info@addi-data.com
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License as published by the Free Software
+ * Foundation; either version 2 of the License, or (at your option) any later
+ * version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
+ * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
+ * details.
+ *
+ */
 
 #define APCI1564_ADDRESS_RANGE				128
 
@@ -115,32 +92,13 @@ static unsigned int ui_InterruptStatus_1564;
 static unsigned int ui_InterruptData, ui_Type;
 
 /*
-+----------------------------------------------------------------------------+
-| Function   Name   : int apci1564_di_config                      |
-|			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
-|                      struct comedi_insn *insn,unsigned int *data)                     |
-+----------------------------------------------------------------------------+
-| Task              : Configures the digital input Subdevice                 |
-+----------------------------------------------------------------------------+
-| Input Parameters  : struct comedi_device *dev : Driver handle                     |
-|                     unsigned int *data         : Data Pointer contains         |
-|                                          configuration parameters as below |
-|                                                                            |
-|			  data[0]            : 1 Enable  Digital Input Interrupt |
-|								   0 Disable Digital Input Interrupt |
-|			  data[1]            : 0 ADDIDATA Interrupt OR LOGIC	 |
-|								 : 1 ADDIDATA Interrupt AND LOGIC    |
-|			  data[2]			 : Interrupt mask for the mode 1	 |
-|			  data[3]			 : Interrupt mask for the mode 2	 |
-|																	 |
-+----------------------------------------------------------------------------+
-| Output Parameters :	--													 |
-+----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error          |
-|			                                                         |
-+----------------------------------------------------------------------------+
-*/
+ * Configures the digital input Subdevice
+ *
+ * data[0] 1 = Enable interrupt, 0 = Disable interrupt
+ * data[1] 0 = ADDIDATA Interrupt OR LOGIC, 1 = ADDIDATA Interrupt AND LOGIC
+ * data[2] Interrupt mask for the mode 1
+ * data[3] Interrupt mask for the mode 2
+ */
 static int apci1564_di_config(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn,
@@ -183,30 +141,11 @@ static int apci1564_di_insn_bits(struct comedi_device *dev,
 }
 
 /*
-+----------------------------------------------------------------------------+
-| Function   Name   : int apci1564_do_config                     |
-|			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
-|                      struct comedi_insn *insn,unsigned int *data)                     |
-+----------------------------------------------------------------------------+
-| Task              : Configures The Digital Output Subdevice.               |
-+----------------------------------------------------------------------------+
-| Input Parameters  : struct comedi_device *dev : Driver handle                     |
-|                     unsigned int *data         : Data Pointer contains             |
-|                                          configuration parameters as below |
-|                                                                            |
-|					  data[1]            : 1 Enable  VCC  Interrupt  |
-|										   0 Disable VCC  Interrupt  |
-|					  data[2]            : 1 Enable  CC  Interrupt   |
-|										   0 Disable CC  Interrupt   |
-|																	 |
-+----------------------------------------------------------------------------+
-| Output Parameters :	--													 |
-+----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error          |
-|			                                                         |
-+----------------------------------------------------------------------------+
-*/
+ * Configures The Digital Output Subdevice.
+ *
+ * data[1] 0 = Disable VCC Interrupt, 1 = Enable VCC Interrupt
+ * data[2] 0 = Disable CC Interrupt, 1 = Enable CC Interrupt
+ */
 static int apci1564_do_config(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn,
@@ -260,35 +199,16 @@ static int apci1564_do_insn_bits(struct comedi_device *dev,
 }
 
 /*
-+----------------------------------------------------------------------------+
-| Function   Name   : int apci1564_timer_config              |
-|			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
-|                      struct comedi_insn *insn,unsigned int *data)                     |
-+----------------------------------------------------------------------------+
-| Task              : Configures The Timer , Counter or Watchdog             |
-+----------------------------------------------------------------------------+
-| Input Parameters  : struct comedi_device *dev : Driver handle                     |
-|                     unsigned int *data         : Data Pointer contains             |
-|                                          configuration parameters as below |
-|                                                                            |
-|					  data[0]            : 0 Configure As Timer      |
-|										   1 Configure As Counter    |
-|										   2 Configure As Watchdog   |
-|					  data[1]            : 1 Enable  Interrupt       |
-|										   0 Disable Interrupt 	     |
-|					  data[2]            : Time Unit                 |
-|					  data[3]			 : Reload Value			     |
-|					  data[4]            : Timer Mode             	 |
-|					  data[5]			 : Timer Counter Watchdog Number|
-                              data[6]            :  Counter Direction
-+----------------------------------------------------------------------------+
-| Output Parameters :	--													 |
-+----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error          |
-|			                                                         |
-+----------------------------------------------------------------------------+
-*/
+ * Configures The Timer, Counter or Watchdog
+ *
+ * data[0] Configure as: 0 = Timer, 1 = Counter, 2 = Watchdog
+ * data[1] 1 = Enable Interrupt, 0 = Disable Interrupt
+ * data[2] Time Unit
+ * data[3] Reload Value
+ * data[4] Timer Mode
+ * data[5] Timer Counter Watchdog Number
+ * data[6] Counter Direction
+ */
 static int apci1564_timer_config(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn,
@@ -383,31 +303,11 @@ static int apci1564_timer_config(struct comedi_device *dev,
 }
 
 /*
-+----------------------------------------------------------------------------+
-| Function   Name   : int apci1564_timer_write      |
-|			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
-|                      struct comedi_insn *insn,unsigned int *data)                     |
-+----------------------------------------------------------------------------+
-| Task              : Start / Stop The Selected Timer , Counter or Watchdog  |
-+----------------------------------------------------------------------------+
-| Input Parameters  : struct comedi_device *dev : Driver handle                     |
-|                     unsigned int *data         : Data Pointer contains             |
-|                                          configuration parameters as below |
-|                                                                            |
-|					  data[0]            : 0 Timer                   |
-|										   1 Counter                 |
-|										   2 Watchdog        		 |                             |					         data[1]            : 1 Start                   |
-|										   0 Stop                    |
-|                                                  2 Trigger             	 |
-|                                                    Clear (Only Counter)    |
-+----------------------------------------------------------------------------+
-| Output Parameters :	--													 |
-+----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error          |
-|			                                                         |
-+----------------------------------------------------------------------------+
-*/
+ * Start / Stop The Selected Timer, Counter or Watchdog
+ *
+ * data[0] Configure as: 0 = Timer, 1 = Counter, 2 = Watchdog
+ * data[1] 0 = Stop, 1 = Start, 2 = Trigger Clear (Only Counter)
+ */
 static int apci1564_timer_write(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn,
@@ -471,26 +371,8 @@ static int apci1564_timer_write(struct comedi_device *dev,
 }
 
 /*
-+----------------------------------------------------------------------------+
-| Function   Name   : int apci1564_timer_read                |
-|			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
-|                      struct comedi_insn *insn,unsigned int *data)                     |
-+----------------------------------------------------------------------------+
-| Task              : Read The Selected Timer , Counter or Watchdog          |
-+----------------------------------------------------------------------------+
-| Input Parameters  : struct comedi_device *dev : Driver handle                     |
-|                     unsigned int *data         : Data Pointer contains             |
-|                                          configuration parameters as below |
-|                                                                            |
-
-+----------------------------------------------------------------------------+
-| Output Parameters :	--													 |
-+----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error          |
-|			                                                         |
-+----------------------------------------------------------------------------+
-*/
+ * Read The Selected Timer, Counter or Watchdog
+ */
 static int apci1564_timer_read(struct comedi_device *dev,
 			       struct comedi_subdevice *s,
 			       struct comedi_insn *insn,
@@ -538,22 +420,8 @@ static int apci1564_timer_read(struct comedi_device *dev,
 }
 
 /*
-+----------------------------------------------------------------------------+
-| Function   Name   :  int apci1564_do_read                    |
-|			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
-|                      struct comedi_insn *insn,unsigned int *data)                     |
-+----------------------------------------------------------------------------+
-| Task              :Reads the interrupt status register                     |
-+----------------------------------------------------------------------------+
-| Input Parameters  :                                                        |
-+----------------------------------------------------------------------------+
-| Output Parameters :	--													 |
-+----------------------------------------------------------------------------+
-| Return Value      :                                                        |
-|			                                                         |
-+----------------------------------------------------------------------------+
-*/
-
+ * Reads the interrupt status register
+ */
 static int apci1564_do_read(struct comedi_device *dev,
 			    struct comedi_subdevice *s,
 			    struct comedi_insn *insn,
@@ -564,22 +432,8 @@ static int apci1564_do_read(struct comedi_device *dev,
 }
 
 /*
-+----------------------------------------------------------------------------+
-| Function   Name   : static void apci1564_interrupt
-|					  (int irq , void *d)      |
-+----------------------------------------------------------------------------+
-| Task              : Interrupt handler for the interruptible digital inputs |
-+----------------------------------------------------------------------------+
-| Input Parameters  : int irq                 : irq number                   |
-|                     void *d                 : void pointer                 |
-+----------------------------------------------------------------------------+
-| Output Parameters :	--													 |
-+----------------------------------------------------------------------------+
-| Return Value      : TRUE  : No error occur                                 |
-|		            : FALSE : Error occur. Return the error          |
-|			                                                         |
-+----------------------------------------------------------------------------+
-*/
+ * Interrupt handler for the interruptible digital inputs
+ */
 static void apci1564_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
@@ -722,21 +576,6 @@ static void apci1564_interrupt(int irq, void *d)
 	return;
 }
 
-/*
-+----------------------------------------------------------------------------+
-| Function   Name   : int apci1564_reset(struct comedi_device *dev)
-+----------------------------------------------------------------------------+
-| Task              :resets all the registers                                |
-+----------------------------------------------------------------------------+
-| Input Parameters  : struct comedi_device *dev
-+----------------------------------------------------------------------------+
-| Output Parameters :	--													 |
-+----------------------------------------------------------------------------+
-| Return Value      :                                                        |
-|			                                                         |
-+----------------------------------------------------------------------------+
-*/
-
 static int apci1564_reset(struct comedi_device *dev)
 {
 	struct addi_private *devpriv = dev->private;
-- 
1.8.5.3

