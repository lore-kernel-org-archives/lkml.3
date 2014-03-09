Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247AbaCICnZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 21:43:25 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:40121 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaCICmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 21:42:53 -0500
Date: Sat, 8 Mar 2014 21:42:49 -0500
From: Conrad Meyer <cemeyer@uw.edu>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Staging: comedi: Kill comment art in hwdrv_apci1500.c
Message-ID: <20140308214249.2262ec0e@m>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nudge the commenting in this mess a little further from 'bad.' Much of
it was incorrectly indented.

Another sed cleanup:
  $ sed -i -e '/\/\*\*\*\*\*\*\*\*\**\//,1d' addi-data/hwdrv_apci1500.c

Signed-off-by: Conrad Meyer <cse.cem@gmail.com>
---
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      | 452 ---------------------
 1 file changed, 452 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
index 0ccf784..4f5ce6a 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
@@ -224,48 +224,44 @@ static int i_TimerCounter1Enabled = 0, i_TimerCounter2Enabled = 0,
 |                                            used for event   				 |
 +----------------------------------------------------------------------------+
 | Output Parameters :	--													 |
 +----------------------------------------------------------------------------+
 | Return Value      : TRUE  : No error occur                                 |
 |		            : FALSE : Error occur. Return the error          |
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
 static int i_APCI1500_ConfigDigitalInputEvent(struct comedi_device *dev,
 					      struct comedi_subdevice *s,
 					      struct comedi_insn *insn,
 					      unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	int i_PatternPolarity = 0, i_PatternTransition = 0, i_PatternMask = 0;
 	int i_MaxChannel = 0, i_Count = 0, i_EventMask = 0;
 	int i_PatternTransitionCount = 0, i_RegValue;
 	int i;
 
-      /*************************************************/
 	/* Selects the master interrupt control register */
-      /*************************************************/
 	outb(APCI1500_RW_MASTER_INTERRUPT_CONTROL,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-      /**********************************************/
 	/* Disables  the main interrupt on the board */
-      /**********************************************/
 	outb(0x00, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 
 	if (data[0] == 1) {
 		i_MaxChannel = 8;
 	}			/*  if (data[0] == 1) */
 	else {
 		if (data[0] == 2) {
 			i_MaxChannel = 6;
 		}		/*  if(data[0]==2) */
 		else {
 			dev_warn(dev->hw_dev,
 				"The specified port event does not exist\n");
 			return -EINVAL;
 		}		/* else if(data[0]==2) */
 	}			/* else  if (data[0] == 1) */
 	switch (data[1]) {
 	case 0:
 		data[1] = APCI1500_AND;
 		break;
 	case 1:
@@ -310,292 +306,238 @@ static int i_APCI1500_ConfigDigitalInputEvent(struct comedi_device *dev,
 					i_Count));
 			i_PatternTransition =
 				i_PatternTransition | (1 << (i_MaxChannel -
 					i_Count));
 			break;
 		case 4:
 			i_PatternTransition =
 				i_PatternTransition | (1 << (i_MaxChannel -
 					i_Count));
 			break;
 		case 5:
 			break;
 		default:
 			dev_warn(dev->hw_dev,
 				"The option indicated in the event mask does not exist\n");
 			return -EINVAL;
 		}		/*  switch(i_EventMask) */
 	}			/* for (i_Count = i_MaxChannel; i_Count >0;i_Count --) */
 
 	if (data[0] == 1) {
-		    /****************************/
 		/* Test the interrupt logic */
-		    /****************************/
 
 		if (data[1] == APCI1500_AND ||
 			data[1] == APCI1500_OR ||
 			data[1] == APCI1500_OR_PRIORITY) {
-		       /**************************************/
 			/* Tests if a transition was declared */
 			/* for a OR PRIORITY logic            */
-		       /**************************************/
 
 			if (data[1] == APCI1500_OR_PRIORITY
 				&& i_PatternTransition != 0) {
 				dev_warn(dev->hw_dev,
 					"Transition error on an OR PRIORITY logic\n");
 				return -EINVAL;
 			}	/*  if (data[1]== APCI1500_OR_PRIORITY && i_PatternTransition != 0) */
 
-		       /*************************************/
 			/* Tests if more than one transition */
 			/* was declared for an AND logic     */
-		       /*************************************/
 
 			if (data[1] == APCI1500_AND) {
 				for (i_Count = 0; i_Count < 8; i_Count++) {
 					i_PatternTransitionCount =
 						i_PatternTransitionCount +
 						((i_PatternTransition >>
 							i_Count) & 0x1);
 
 				}	/* for (i_Count = 0; i_Count < 8; i_Count++) */
 
 				if (i_PatternTransitionCount > 1) {
 					dev_warn(dev->hw_dev,
 						"Transition error on an AND logic\n");
 					return -EINVAL;
 				}	/*  if (i_PatternTransitionCount > 1) */
 			}	/*  if (data[1]== APCI1500_AND) */
 
-			    /*****************************************************************/
 			/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
-			    /*****************************************************************/
 			outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
-			/******************/
 			/* Disable Port A */
-			    /******************/
 			outb(0xF0,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
-			/**********************************************/
 			/* Selects the polarity register of port 1    */
-			    /**********************************************/
 			outb(APCI1500_RW_PORT_A_PATTERN_POLARITY,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			outb(i_PatternPolarity,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 
-			/*********************************************/
 			/* Selects the pattern mask register of      */
 			/* port 1                                    */
-			    /*********************************************/
 			outb(APCI1500_RW_PORT_A_PATTERN_MASK,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			outb(i_PatternMask,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
-			/********************************************/
 			/* Selects the pattern transition register  */
 			/* of port 1                                */
-			    /********************************************/
 			outb(APCI1500_RW_PORT_A_PATTERN_TRANSITION,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			outb(i_PatternTransition,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 
-		      /******************************************/
 			/* Selects the mode specification mask    */
 			/* register of port 1                     */
-			  /******************************************/
 			outb(APCI1500_RW_PORT_A_SPECIFICATION,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			i_RegValue =
 				inb(devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 
-		      /******************************************/
 			/* Selects the mode specification mask    */
 			/* register of port 1                     */
-			  /******************************************/
 			outb(APCI1500_RW_PORT_A_SPECIFICATION,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 
-		      /**********************/
 			/* Port A new mode    */
-			  /**********************/
 
 			i_RegValue = (i_RegValue & 0xF9) | data[1] | 0x9;
 			outb(i_RegValue,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 
 			i_Event1Status = 1;
 
-		      /*****************************************************************/
 			/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
-			  /*****************************************************************/
 
 			outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
-		      /*****************/
 			/* Enable Port A */
-			  /*****************/
 			outb(0xF4,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 
 		}		/*  if(data[1]==APCI1500_AND||data[1]==APCI1500_OR||data[1]==APCI1500_OR_PRIORITY) */
 		else {
 			dev_warn(dev->hw_dev,
 				"The choice for interrupt logic does not exist\n");
 			return -EINVAL;
 		}		/*  else }// if(data[1]==APCI1500_AND||data[1]==APCI1500_OR||data[1]==APCI1500_OR_PRIORITY) */
 	}			/*    if (data[0]== 1) */
 
-		 /************************************/
 	/* Test if event setting for port 2 */
-		 /************************************/
 
 	if (data[0] == 2) {
-		    /************************/
 		/* Test the event logic */
-		    /************************/
 
 		if (data[1] == APCI1500_OR) {
-		       /*****************************************************************/
 			/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
-		       /*****************************************************************/
 			outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
-		       /******************/
 			/* Disable Port B */
-		       /******************/
 			outb(0x74,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
-		       /****************************************/
 			/* Selects the mode specification mask  */
 			/* register of port B                   */
-		       /****************************************/
 			outb(APCI1500_RW_PORT_B_SPECIFICATION,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			i_RegValue =
 				inb(devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 
-		       /******************************************/
 			/* Selects the mode specification mask    */
 			/* register of port B                     */
-		       /******************************************/
 			outb(APCI1500_RW_PORT_B_SPECIFICATION,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			i_RegValue = i_RegValue & 0xF9;
 			outb(i_RegValue,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 
-		       /**********************************/
 			/* Selects error channels 1 and 2 */
-		       /**********************************/
 
 			i_PatternMask = (i_PatternMask | 0xC0);
 			i_PatternPolarity = (i_PatternPolarity | 0xC0);
 			i_PatternTransition = (i_PatternTransition | 0xC0);
 
-		       /**********************************************/
 			/* Selects the polarity register of port 2    */
-		       /**********************************************/
 			outb(APCI1500_RW_PORT_B_PATTERN_POLARITY,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			outb(i_PatternPolarity,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
-		       /**********************************************/
 			/* Selects the pattern transition register    */
 			/* of port 2                                  */
-		       /**********************************************/
 			outb(APCI1500_RW_PORT_B_PATTERN_TRANSITION,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			outb(i_PatternTransition,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
-		       /**********************************************/
 			/* Selects the pattern Mask register    */
 			/* of port 2                                  */
-		       /**********************************************/
 
 			outb(APCI1500_RW_PORT_B_PATTERN_MASK,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			outb(i_PatternMask,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 
-		       /******************************************/
 			/* Selects the mode specification mask    */
 			/* register of port 2                     */
-		       /******************************************/
 			outb(APCI1500_RW_PORT_B_SPECIFICATION,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			i_RegValue =
 				inb(devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
-		       /******************************************/
 			/* Selects the mode specification mask    */
 			/* register of port 2                     */
-		       /******************************************/
 			outb(APCI1500_RW_PORT_B_SPECIFICATION,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			i_RegValue = (i_RegValue & 0xF9) | 4;
 			outb(i_RegValue,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 
 			i_Event2Status = 1;
-		       /*****************************************************************/
 			/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
-		       /*****************************************************************/
 
 			outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
-		       /*****************/
 			/* Enable Port B */
-		       /*****************/
 
 			outb(0xF4,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 		}		/*   if (data[1] == APCI1500_OR) */
 		else {
 			dev_warn(dev->hw_dev,
 				"The choice for interrupt logic does not exist\n");
 			return -EINVAL;
 		}		/* elseif (data[1] == APCI1500_OR) */
 	}			/* if(data[0]==2) */
 
 	return insn->n;
 }
 
 /*
 +----------------------------------------------------------------------------+
 | Function   Name   : int i_APCI1500_StartStopInputEvent                     |
 |			  (struct comedi_device *dev,struct comedi_subdevice *s,               |
 |                      struct comedi_insn *insn,unsigned int *data)                     |
@@ -610,258 +552,190 @@ static int i_APCI1500_ConfigDigitalInputEvent(struct comedi_device *dev,
 |                      data[1]                 :No of port (1 or 2)
 +----------------------------------------------------------------------------+
 | Output Parameters :	--													 |
 +----------------------------------------------------------------------------+
 | Return Value      : TRUE  : No error occur                                 |
 |		            : FALSE : Error occur. Return the error          |
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
 static int i_APCI1500_StartStopInputEvent(struct comedi_device *dev,
 					  struct comedi_subdevice *s,
 					  struct comedi_insn *insn,
 					  unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	int i_Event1InterruptStatus = 0, i_Event2InterruptStatus =
 		0, i_RegValue;
 
 	switch (data[0]) {
 	case START:
-	      /*************************/
 		/* Tests the port number */
-	      /*************************/
 
 		if (data[1] == 1 || data[1] == 2) {
-		  /***************************/
 			/* Test if port 1 selected */
-		  /***************************/
 
 			if (data[1] == 1) {
-		    /*****************************/
 				/* Test if event initialised */
-		    /*****************************/
 				if (i_Event1Status == 1) {
-		       /*****************************************************************/
 					/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
-		       /*****************************************************************/
 					outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-		       /******************/
 					/* Disable Port A */
-		       /******************/
 					outb(0xF0,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
-		       /***************************************************/
 					/* Selects the command and status register of      */
 					/* port 1                                          */
-		       /***************************************************/
 					outb(APCI1500_RW_PORT_A_COMMAND_AND_STATUS, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-		       /*************************************/
 					/* Allows the pattern interrupt      */
-		       /*************************************/
 					outb(0xC0,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
-		       /*****************************************************************/
 					/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
-		       /*****************************************************************/
 					outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-		       /*****************/
 					/* Enable Port A */
-		       /*****************/
 					outb(0xF4,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 					i_Event1InterruptStatus = 1;
 					outb(APCI1500_RW_PORT_A_SPECIFICATION,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 					i_RegValue =
 						inb(devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 
 					/* Selects the master interrupt control register */
-		       /*************************************************/
 					outb(APCI1500_RW_MASTER_INTERRUPT_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-		       /**********************************************/
 					/* Authorizes the main interrupt on the board */
-		       /**********************************************/
 					outb(0xD0,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 
 				}	/*  if(i_Event1Status==1) */
 				else {
 					dev_warn(dev->hw_dev,
 						"Event 1 not initialised\n");
 					return -EINVAL;
 				}	/* else if(i_Event1Status==1) */
 			}	/* if (data[1]==1) */
 			if (data[1] == 2) {
 
 				if (i_Event2Status == 1) {
-			    /*****************************************************************/
 					/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
-			    /*****************************************************************/
 					outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-		       /******************/
 					/* Disable Port B */
-		       /******************/
 					outb(0x74,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
-		       /***************************************************/
 					/* Selects the command and status register of      */
 					/* port 2                                          */
-		       /***************************************************/
 					outb(APCI1500_RW_PORT_B_COMMAND_AND_STATUS, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-		       /*************************************/
 					/* Allows the pattern interrupt      */
-		       /*************************************/
 					outb(0xC0,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
-		       /*****************************************************************/
 					/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
-		       /*****************************************************************/
 					outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-		       /*****************/
 					/* Enable Port B */
-		       /*****************/
 					outb(0xF4,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 
 					/* Selects the master interrupt control register */
-		       /*************************************************/
 					outb(APCI1500_RW_MASTER_INTERRUPT_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-		       /**********************************************/
 					/* Authorizes the main interrupt on the board */
-		       /**********************************************/
 					outb(0xD0,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 					i_Event2InterruptStatus = 1;
 				}	/*  if(i_Event2Status==1) */
 				else {
 					dev_warn(dev->hw_dev,
 						"Event 2 not initialised\n");
 					return -EINVAL;
 				}	/* else if(i_Event2Status==1) */
 			}	/*  if(data[1]==2) */
 		}		/*  if (data[1] == 1 || data[0] == 2) */
 		else {
 			dev_warn(dev->hw_dev,
 				"The port parameter is in error\n");
 			return -EINVAL;
 		}		/* else if (data[1] == 1 || data[0] == 2) */
 
 		break;
 
 	case STOP:
-		  /*************************/
 		/* Tests the port number */
-		  /*************************/
 
 		if (data[1] == 1 || data[1] == 2) {
-		  /***************************/
 			/* Test if port 1 selected */
-		  /***************************/
 
 			if (data[1] == 1) {
-		    /*****************************/
 				/* Test if event initialised */
-		    /*****************************/
 				if (i_Event1Status == 1) {
-		       /*****************************************************************/
 					/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
-		       /*****************************************************************/
 					outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-		       /******************/
 					/* Disable Port A */
-		       /******************/
 					outb(0xF0,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
-		       /***************************************************/
 					/* Selects the command and status register of      */
 					/* port 1                                          */
-		       /***************************************************/
 					outb(APCI1500_RW_PORT_A_COMMAND_AND_STATUS, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-		       /*************************************/
 					/* Inhibits the pattern interrupt      */
-		       /*************************************/
 					outb(0xE0,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
-		       /*****************************************************************/
 					/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
-		       /*****************************************************************/
 					outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-		       /*****************/
 					/* Enable Port A */
-		       /*****************/
 					outb(0xF4,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 					i_Event1InterruptStatus = 0;
 				}	/*  if(i_Event1Status==1) */
 				else {
 					dev_warn(dev->hw_dev,
 						"Event 1 not initialised\n");
 					return -EINVAL;
 				}	/* else if(i_Event1Status==1) */
 			}	/* if (data[1]==1) */
 			if (data[1] == 2) {
-			 /*****************************/
 				/* Test if event initialised */
-			 /*****************************/
 				if (i_Event2Status == 1) {
-			  /*****************************************************************/
 					/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
-			  /*****************************************************************/
 					outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-			  /******************/
 					/* Disable Port B */
-			  /******************/
 					outb(0x74,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
-			  /***************************************************/
 					/* Selects the command and status register of      */
 					/* port 2                                         */
-			  /***************************************************/
 					outb(APCI1500_RW_PORT_B_COMMAND_AND_STATUS, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-		       /*************************************/
 					/* Inhibits the pattern interrupt      */
-		       /*************************************/
 					outb(0xE0,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
-		       /*****************************************************************/
 					/* Selects the APCI1500_RW_MASTER_CONFIGURATION_CONTROL register */
-		       /*****************************************************************/
 					outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-		       /*****************/
 					/* Enable Port B */
-		       /*****************/
 					outb(0xF4,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 					i_Event2InterruptStatus = 0;
 				}	/*  if(i_Event2Status==1) */
 				else {
 					dev_warn(dev->hw_dev,
 						"Event 2 not initialised\n");
 					return -EINVAL;
 				}	/* else if(i_Event2Status==1) */
 			}	/* if(data[1]==2) */
 
 		}		/*  if (data[1] == 1 || data[1] == 2) */
 		else {
 			dev_warn(dev->hw_dev,
 				"The port parameter is in error\n");
 			return -EINVAL;
 		}		/* else if (data[1] == 1 || data[1] == 2) */
 		break;
 	default:
@@ -883,179 +757,161 @@ static int i_APCI1500_StartStopInputEvent(struct comedi_device *dev,
 +----------------------------------------------------------------------------+
 | Input Parameters  : struct comedi_device *dev      : Driver handle                |
 |		              unsigned int ui_Channel : Channel number to read       |
 |                     unsigned int *data          : Data Pointer to read status  |
 +----------------------------------------------------------------------------+
 | Output Parameters :	--													 |
 +----------------------------------------------------------------------------+
 | Return Value      : TRUE  : No error occur                                 |
 |		            : FALSE : Error occur. Return the error          |
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
 static int i_APCI1500_Initialisation(struct comedi_device *dev,
 				     struct comedi_subdevice *s,
 				     struct comedi_insn *insn,
 				     unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	int i_DummyRead = 0;
 
-    /******************/
 	/* Software reset */
-    /******************/
 	i_DummyRead = inb(devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	outb(0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	i_DummyRead = inb(devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	outb(0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	outb(1, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	outb(0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 
- /*****************************************************/
 	/* Selects the master configuration control register */
- /*****************************************************/
 	outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	outb(0xF4, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 
-	/*****************************************************/
 	/* Selects the mode specification register of port A */
-	/*****************************************************/
 	outb(APCI1500_RW_PORT_A_SPECIFICATION,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	outb(0x10, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 
 	/* Selects the data path polarity register of port A */
 	outb(APCI1500_RW_PORT_A_DATA_PCITCH_POLARITY,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* High level of port A means 1 */
 	outb(0xFF, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 
 	/* Selects the data direction register of port A */
 	outb(APCI1500_RW_PORT_A_DATA_DIRECTION,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* All bits used as inputs */
 	outb(0xFF, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the command and status register of port A */
 	outb(APCI1500_RW_PORT_A_COMMAND_AND_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deletes IP and IUS */
 	outb(0x20, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/*  Selects the command and status register of port A */
 	outb(APCI1500_RW_PORT_A_COMMAND_AND_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deactivates the interrupt management of port A:  */
 	outb(0xE0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the handshake specification register of port A */
 	outb(APCI1500_RW_PORT_A_HANDSHAKE_SPECIFICATION,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deletes the register */
 	outb(0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 
-	 /*****************************************************/
 	/* Selects the mode specification register of port B */
-	 /*****************************************************/
 	outb(APCI1500_RW_PORT_B_SPECIFICATION,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	outb(0x10, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the data path polarity register of port B */
 	outb(APCI1500_RW_PORT_B_DATA_PCITCH_POLARITY,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* A high level of port B means 1 */
 	outb(0x7F, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the data direction register of port B */
 	outb(APCI1500_RW_PORT_B_DATA_DIRECTION,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* All bits used as inputs */
 	outb(0xFF, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the command and status register of port B */
 	outb(APCI1500_RW_PORT_B_COMMAND_AND_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deletes IP and IUS */
 	outb(0x20, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the command and status register of port B */
 	outb(APCI1500_RW_PORT_B_COMMAND_AND_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deactivates the interrupt management of port B:         */
 	outb(0xE0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the handshake specification register of port B */
 	outb(APCI1500_RW_PORT_B_HANDSHAKE_SPECIFICATION,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deletes the register */
 	outb(0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 
-	   /*****************************************************/
 	/* Selects the data path polarity register of port C */
-	   /*****************************************************/
 	outb(APCI1500_RW_PORT_C_DATA_PCITCH_POLARITY,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* High level of port C means 1 */
 	outb(0x9, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the data direction register of port C */
 	outb(APCI1500_RW_PORT_C_DATA_DIRECTION,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* All bits used as inputs except channel 1 */
 	outb(0x0E, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the special IO register of port C */
 	outb(APCI1500_RW_PORT_C_SPECIAL_IO_CONTROL,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deletes it */
 	outb(0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-	   /******************************************************/
 	/* Selects the command and status register of timer 1 */
-	   /******************************************************/
 	outb(APCI1500_RW_CPT_TMR1_CMD_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deletes IP and IUS */
 	outb(0x20, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the command and status register of timer 1 */
 	outb(APCI1500_RW_CPT_TMR1_CMD_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deactivates the interrupt management of timer 1         */
 	outb(0xE0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-	   /******************************************************/
 	/* Selects the command and status register of timer 2 */
-	   /******************************************************/
 	outb(APCI1500_RW_CPT_TMR2_CMD_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deletes IP and IUS */
 	outb(0x20, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the command and status register of timer 2 */
 	outb(APCI1500_RW_CPT_TMR2_CMD_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deactivates Timer 2 interrupt management:               */
 	outb(0xE0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-	  /******************************************************/
 	/* Selects the command and status register of timer 3 */
-	  /******************************************************/
 	outb(APCI1500_RW_CPT_TMR3_CMD_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deletes IP and IUS */
 	outb(0x20, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the command and status register of Timer 3 */
 	outb(APCI1500_RW_CPT_TMR3_CMD_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deactivates interrupt management of timer 3:            */
 	outb(0xE0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-	 /*************************************************/
 	/* Selects the master interrupt control register */
-	 /*************************************************/
 	outb(APCI1500_RW_MASTER_INTERRUPT_CONTROL,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deletes all interrupts */
 	outb(0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	return insn->n;
 }
 
 static int apci1500_di_insn_bits(struct comedi_device *dev,
 				 struct comedi_subdevice *s,
 				 struct comedi_insn *insn,
 				 unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 
 	data[1] = inw(devpriv->i_IobaseAddon + APCI1500_DIGITAL_IP);
 
 	return insn->n;
 }
 
 /*
@@ -1351,157 +1207,125 @@ static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 			dev_warn(dev->hw_dev,
 				"This choice is not a timer nor a counter\n");
 			return -EINVAL;
 		}		/*  switch(data[2]) */
 
 		/* Selecting  single or continuous mode */
 		switch (data[4]) {
 		case 0:
 			data[4] = APCI1500_CONTINUOUS;
 			break;
 		case 1:
 			data[4] = APCI1500_SINGLE;
 			break;
 		default:
 			dev_warn(dev->hw_dev,
 				"This option for single/continuous mode does not exist\n");
 			return -EINVAL;
 		}		/*  switch(data[4]) */
 
 		i_TimerCounterMode = data[2] | data[4] | 7;
-			 /*************************/
 		/* Test the reload value */
-			 /*************************/
 
 		if ((data[3] >= 0) && (data[3] <= 65535)) {
 			if (data[7] == APCI1500_ENABLE
 				|| data[7] == APCI1500_DISABLE) {
 
-				/************************************************/
 				/* Selects the mode register of timer/counter 1 */
-				/************************************************/
 				outb(APCI1500_RW_CPT_TMR1_MODE_SPECIFICATION,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
-				/***********************/
 				/* Writes the new mode */
-				/***********************/
 				outb(i_TimerCounterMode,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				/****************************************************/
 				/* Selects the constant register of timer/counter 1 */
-				/****************************************************/
 
 				outb(APCI1500_RW_CPT_TMR1_TIME_CST_LOW,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				  /*************************/
 				/* Writes the low value  */
-				  /*************************/
 
 				outb(data[3],
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				   /****************************************************/
 				/* Selects the constant register of timer/counter 1 */
-				   /****************************************************/
 
 				outb(APCI1500_RW_CPT_TMR1_TIME_CST_HIGH,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				  /**************************/
 				/* Writes the high value  */
-				  /**************************/
 
 				data[3] = data[3] >> 8;
 				outb(data[3],
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				     /*********************************************/
 				/* Selects the master configuration register */
-				     /*********************************************/
 
 				outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				     /**********************/
 				/* Reads the register */
-				     /**********************/
 
 				i_MasterConfiguration =
 					inb(devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				       /********************************************************/
 				/* Enables timer/counter 1 and triggers timer/counter 1 */
-				       /********************************************************/
 
 				i_MasterConfiguration =
 					i_MasterConfiguration | 0x40;
 
-				    /*********************************************/
 				/* Selects the master configuration register */
-				    /*********************************************/
 				outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				      /********************************/
 				/* Writes the new configuration */
-				      /********************************/
 				outb(i_MasterConfiguration,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
-					 /****************************************/
 				/* Selects the commands register of     */
 				/* timer/counter 1                      */
-					 /****************************************/
 
 				outb(APCI1500_RW_CPT_TMR1_CMD_STATUS,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				       /***************************/
 				/* Disable timer/counter 1 */
-				       /***************************/
 
 				outb(0x0,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
-					  /****************************************/
 				/* Selects the commands register of     */
 				/* timer/counter 1                      */
-					  /****************************************/
 				outb(APCI1500_RW_CPT_TMR1_CMD_STATUS,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				      /***************************/
 				/* Trigger timer/counter 1 */
-				      /***************************/
 				outb(0x2,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 			}	/* if(data[7]== APCI1500_ENABLE ||data[7]== APCI1500_DISABLE) */
 			else {
 				dev_warn(dev->hw_dev,
 					"Error in selection of interrupt enable or disable\n");
 				return -EINVAL;
 			}	/* elseif(data[7]== APCI1500_ENABLE ||data[7]== APCI1500_DISABLE) */
 		}		/*  if ((data[3]>= 0) && (data[3] <= 65535)) */
 		else {
 			dev_warn(dev->hw_dev,
 				"Error in selection of reload value\n");
 			return -EINVAL;
 		}		/* else if ((data[3]>= 0) && (data[3] <= 65535)) */
 		i_TimerCounterWatchdogInterrupt = data[7];
 		i_TimerCounter1Init = 1;
 		break;
 
 	case COUNTER2:		/* selecting counter or timer */
@@ -1545,157 +1369,125 @@ static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 				"This choice for software or hardware trigger does not exist\n");
 			return -EINVAL;
 		}		/*  switch(data[5]) */
 
 		/* Selecting  software or hardware gate */
 		switch (data[6]) {
 		case 0:
 			data[6] = APCI1500_SOFTWARE_GATE;
 			break;
 		case 1:
 			data[6] = APCI1500_HARDWARE_GATE;
 			break;
 		default:
 			dev_warn(dev->hw_dev,
 				"This choice for software or hardware gate does not exist\n");
 			return -EINVAL;
 		}		/*  switch(data[6]) */
 
 		i_TimerCounterMode = data[2] | data[4] | data[5] | data[6] | 7;
 
-			     /*************************/
 		/* Test the reload value */
-			     /*************************/
 
 		if ((data[3] >= 0) && (data[3] <= 65535)) {
 			if (data[7] == APCI1500_ENABLE
 				|| data[7] == APCI1500_DISABLE) {
 
-				/************************************************/
 				/* Selects the mode register of timer/counter 2 */
-				/************************************************/
 				outb(APCI1500_RW_CPT_TMR2_MODE_SPECIFICATION,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
-				/***********************/
 				/* Writes the new mode */
-				/***********************/
 				outb(i_TimerCounterMode,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				/****************************************************/
 				/* Selects the constant register of timer/counter 2 */
-				/****************************************************/
 
 				outb(APCI1500_RW_CPT_TMR2_TIME_CST_LOW,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				  /*************************/
 				/* Writes the low value  */
-				  /*************************/
 
 				outb(data[3],
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				   /****************************************************/
 				/* Selects the constant register of timer/counter 2 */
-				   /****************************************************/
 
 				outb(APCI1500_RW_CPT_TMR2_TIME_CST_HIGH,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				  /**************************/
 				/* Writes the high value  */
-				  /**************************/
 
 				data[3] = data[3] >> 8;
 				outb(data[3],
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				     /*********************************************/
 				/* Selects the master configuration register */
-				     /*********************************************/
 
 				outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				     /**********************/
 				/* Reads the register */
-				     /**********************/
 
 				i_MasterConfiguration =
 					inb(devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				       /********************************************************/
 				/* Enables timer/counter 2 and triggers timer/counter 2 */
-				       /********************************************************/
 
 				i_MasterConfiguration =
 					i_MasterConfiguration | 0x20;
 
-				    /*********************************************/
 				/* Selects the master configuration register */
-				    /*********************************************/
 				outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				      /********************************/
 				/* Writes the new configuration */
-				      /********************************/
 				outb(i_MasterConfiguration,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
-					 /****************************************/
 				/* Selects the commands register of     */
 				/* timer/counter 2                      */
-					 /****************************************/
 
 				outb(APCI1500_RW_CPT_TMR2_CMD_STATUS,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				       /***************************/
 				/* Disable timer/counter 2 */
-				       /***************************/
 
 				outb(0x0,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
-					  /****************************************/
 				/* Selects the commands register of     */
 				/* timer/counter 2                      */
-					  /****************************************/
 				outb(APCI1500_RW_CPT_TMR2_CMD_STATUS,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				      /***************************/
 				/* Trigger timer/counter 1 */
-				      /***************************/
 				outb(0x2,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 			}	/* if(data[7]== APCI1500_ENABLE ||data[7]== APCI1500_DISABLE) */
 			else {
 				dev_warn(dev->hw_dev,
 					"Error in selection of interrupt enable or disable\n");
 				return -EINVAL;
 			}	/* elseif(data[7]== APCI1500_ENABLE ||data[7]== APCI1500_DISABLE) */
 		}		/*  if ((data[3]>= 0) && (data[3] <= 65535)) */
 		else {
 			dev_warn(dev->hw_dev,
 				"Error in selection of reload value\n");
 			return -EINVAL;
 		}		/* else if ((data[3]>= 0) && (data[3] <= 65535)) */
 		i_TimerCounterWatchdogInterrupt = data[7];
 		i_TimerCounter2Init = 1;
 		break;
 
 	case COUNTER3:		/* selecting counter or watchdog */
@@ -1723,176 +1515,138 @@ static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 		default:
 			dev_warn(dev->hw_dev,
 				"This option for single/continuous mode does not exist\n");
 			return -EINVAL;
 		}		/*  switch(data[4]) */
 
 		/* Selecting  software or hardware gate */
 		switch (data[6]) {
 		case 0:
 			data[6] = APCI1500_SOFTWARE_GATE;
 			break;
 		case 1:
 			data[6] = APCI1500_HARDWARE_GATE;
 			break;
 		default:
 			dev_warn(dev->hw_dev,
 				"This choice for software or hardware gate does not exist\n");
 			return -EINVAL;
 		}		/*  switch(data[6]) */
 
-		      /*****************************/
 		/* Test if used for watchdog */
-			  /*****************************/
 
 		if (data[2] == APCI1500_WATCHDOG) {
-			     /*****************************/
 			/* - Enables the output line */
 			/* - Enables retrigger       */
 			/* - Pulses output           */
-			     /*****************************/
 			i_TimerCounterMode = data[2] | data[4] | 0x54;
 		}		/* if (data[2] == APCI1500_WATCHDOG) */
 		else {
 			i_TimerCounterMode = data[2] | data[4] | data[6] | 7;
 		}		/* elseif (data[2] == APCI1500_WATCHDOG) */
-				 /*************************/
 		/* Test the reload value */
-			     /*************************/
 
 		if ((data[3] >= 0) && (data[3] <= 65535)) {
 			if (data[7] == APCI1500_ENABLE
 				|| data[7] == APCI1500_DISABLE) {
 
-				/************************************************/
 				/* Selects the mode register of watchdog/counter 3 */
-				/************************************************/
 				outb(APCI1500_RW_CPT_TMR3_MODE_SPECIFICATION,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
-				/***********************/
 				/* Writes the new mode */
-				/***********************/
 				outb(i_TimerCounterMode,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				/****************************************************/
 				/* Selects the constant register of watchdog/counter 3 */
-				/****************************************************/
 
 				outb(APCI1500_RW_CPT_TMR3_TIME_CST_LOW,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				  /*************************/
 				/* Writes the low value  */
-				  /*************************/
 
 				outb(data[3],
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				   /****************************************************/
 				/* Selects the constant register of watchdog/counter 3 */
-				   /****************************************************/
 
 				outb(APCI1500_RW_CPT_TMR3_TIME_CST_HIGH,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				  /**************************/
 				/* Writes the high value  */
-				  /**************************/
 
 				data[3] = data[3] >> 8;
 				outb(data[3],
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				     /*********************************************/
 				/* Selects the master configuration register */
-				     /*********************************************/
 
 				outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				     /**********************/
 				/* Reads the register */
-				     /**********************/
 
 				i_MasterConfiguration =
 					inb(devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				       /********************************************************/
 				/* Enables watchdog/counter 3 and triggers watchdog/counter 3 */
-				       /********************************************************/
 
 				i_MasterConfiguration =
 					i_MasterConfiguration | 0x10;
 
-				    /*********************************************/
 				/* Selects the master configuration register */
-				    /*********************************************/
 				outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				      /********************************/
 				/* Writes the new configuration */
-				      /********************************/
 				outb(i_MasterConfiguration,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-				      /********************/
 				/* Test if COUNTER */
-					  /********************/
 				if (data[2] == APCI1500_COUNTER) {
 
-					    /*************************************/
 					/* Selects the command register of   */
 					/* watchdog/counter 3                */
-						 /*************************************/
 					outb(APCI1500_RW_CPT_TMR3_CMD_STATUS,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
-					      /*************************************************/
 					/* Disable the  watchdog/counter 3 and starts it */
-						  /*************************************************/
 					outb(0x0,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 
-					      /*************************************/
 					/* Selects the command register of   */
 					/* watchdog/counter 3                */
-						  /*************************************/
 
 					outb(APCI1500_RW_CPT_TMR3_CMD_STATUS,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
-					     /*************************************************/
 					/* Trigger the  watchdog/counter 3 and starts it */
-						 /*************************************************/
 					outb(0x2,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 
 				}	/* elseif(data[2]==APCI1500_COUNTER) */
 
 			}	/* if(data[7]== APCI1500_ENABLE ||data[7]== APCI1500_DISABLE) */
 			else {
 				dev_warn(dev->hw_dev,
 					"Error in selection of interrupt enable or disable\n");
 				return -EINVAL;
 			}	/* elseif(data[7]== APCI1500_ENABLE ||data[7]== APCI1500_DISABLE) */
 		}		/*  if ((data[3]>= 0) && (data[3] <= 65535)) */
 		else {
 			dev_warn(dev->hw_dev,
 				"Error in selection of reload value\n");
 			return -EINVAL;
 		}		/* else if ((data[3]>= 0) && (data[3] <= 65535)) */
 		i_TimerCounterWatchdogInterrupt = data[7];
 		i_WatchdogCounter3Init = 1;
@@ -1936,300 +1690,256 @@ static int i_APCI1500_ConfigCounterTimerWatchdog(struct comedi_device *dev,
 +----------------------------------------------------------------------------+
 */
 static int i_apci1500_timer_watchdog(struct comedi_device *dev,
 	struct comedi_subdevice *s, struct comedi_insn *insn,
 	unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	int i_CommandAndStatusValue;
 
 	switch (data[0]) {
 	case COUNTER1:
 		switch (data[1]) {
 		case START:
 			if (i_TimerCounter1Init == 1) {
 				if (i_TimerCounterWatchdogInterrupt == 1) {
 					i_CommandAndStatusValue = 0xC4;	/* Enable the interrupt */
 				}	/*  if(i_TimerCounterWatchdogInterrupt==1) */
 				else {
 					i_CommandAndStatusValue = 0xE4;	/* disable the interrupt */
 				}	/* elseif(i_TimerCounterWatchdogInterrupt==1) */
-					      /**************************/
 				/* Starts timer/counter 1 */
-					      /**************************/
 				i_TimerCounter1Enabled = 1;
-						/********************************************/
 				/* Selects the commands and status register */
-						/********************************************/
 				outb(APCI1500_RW_CPT_TMR1_CMD_STATUS,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 				outb(i_CommandAndStatusValue,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 			}	/* if( i_TimerCounter1Init==1) */
 			else {
 				dev_warn(dev->hw_dev,
 					"Counter/Timer1 not configured\n");
 				return -EINVAL;
 			}
 			break;
 
 		case STOP:
 
-					      /**************************/
 			/* Stop timer/counter 1 */
-					      /**************************/
 
-						/********************************************/
 			/* Selects the commands and status register */
-						/********************************************/
 			outb(APCI1500_RW_CPT_TMR1_CMD_STATUS,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			outb(0x00,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			i_TimerCounter1Enabled = 0;
 			break;
 
 		case TRIGGER:
 			if (i_TimerCounter1Init == 1) {
 				if (i_TimerCounter1Enabled == 1) {
-						 /************************/
 					/* Set Trigger and gate */
-						 /************************/
 
 					i_CommandAndStatusValue = 0x6;
 				}	/* if( i_TimerCounter1Enabled==1) */
 				else {
-						   /***************/
 					/* Set Trigger */
-						   /***************/
 
 					i_CommandAndStatusValue = 0x2;
 				}	/* elseif(i_TimerCounter1Enabled==1) */
 
-						/********************************************/
 				/* Selects the commands and status register */
-						/********************************************/
 				outb(APCI1500_RW_CPT_TMR1_CMD_STATUS,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 				outb(i_CommandAndStatusValue,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 			}	/* if( i_TimerCounter1Init==1) */
 			else {
 				dev_warn(dev->hw_dev,
 					"Counter/Timer1 not configured\n");
 				return -EINVAL;
 			}
 			break;
 
 		default:
 			dev_warn(dev->hw_dev,
 				"The specified option for start/stop/trigger does not exist\n");
 			return -EINVAL;
 		}		/* switch(data[1]) */
 		break;
 
 	case COUNTER2:
 		switch (data[1]) {
 		case START:
 			if (i_TimerCounter2Init == 1) {
 				if (i_TimerCounterWatchdogInterrupt == 1) {
 					i_CommandAndStatusValue = 0xC4;	/* Enable the interrupt */
 				}	/*  if(i_TimerCounterWatchdogInterrupt==1) */
 				else {
 					i_CommandAndStatusValue = 0xE4;	/* disable the interrupt */
 				}	/* elseif(i_TimerCounterWatchdogInterrupt==1) */
-					      /**************************/
 				/* Starts timer/counter 2 */
-					      /**************************/
 				i_TimerCounter2Enabled = 1;
-						/********************************************/
 				/* Selects the commands and status register */
-						/********************************************/
 				outb(APCI1500_RW_CPT_TMR2_CMD_STATUS,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 				outb(i_CommandAndStatusValue,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 			}	/* if( i_TimerCounter2Init==1) */
 			else {
 				dev_warn(dev->hw_dev,
 					"Counter/Timer2 not configured\n");
 				return -EINVAL;
 			}
 			break;
 
 		case STOP:
 
-					      /**************************/
 			/* Stop timer/counter 2 */
-					      /**************************/
 
-						/********************************************/
 			/* Selects the commands and status register */
-						/********************************************/
 			outb(APCI1500_RW_CPT_TMR2_CMD_STATUS,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			outb(0x00,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			i_TimerCounter2Enabled = 0;
 			break;
 		case TRIGGER:
 			if (i_TimerCounter2Init == 1) {
 				if (i_TimerCounter2Enabled == 1) {
-						 /************************/
 					/* Set Trigger and gate */
-						 /************************/
 
 					i_CommandAndStatusValue = 0x6;
 				}	/* if( i_TimerCounter2Enabled==1) */
 				else {
-						   /***************/
 					/* Set Trigger */
-						   /***************/
 
 					i_CommandAndStatusValue = 0x2;
 				}	/* elseif(i_TimerCounter2Enabled==1) */
 
-						/********************************************/
 				/* Selects the commands and status register */
-						/********************************************/
 				outb(APCI1500_RW_CPT_TMR2_CMD_STATUS,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 				outb(i_CommandAndStatusValue,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 			}	/* if( i_TimerCounter2Init==1) */
 			else {
 				dev_warn(dev->hw_dev,
 					"Counter/Timer2 not configured\n");
 				return -EINVAL;
 			}
 			break;
 		default:
 			dev_warn(dev->hw_dev,
 				"The specified option for start/stop/trigger does not exist\n");
 			return -EINVAL;
 		}		/* switch(data[1]) */
 		break;
 	case COUNTER3:
 		switch (data[1]) {
 		case START:
 			if (i_WatchdogCounter3Init == 1) {
 
 				if (i_TimerCounterWatchdogInterrupt == 1) {
 					i_CommandAndStatusValue = 0xC4;	/* Enable the interrupt */
 				}	/*  if(i_TimerCounterWatchdogInterrupt==1) */
 				else {
 					i_CommandAndStatusValue = 0xE4;	/* disable the interrupt */
 				}	/* elseif(i_TimerCounterWatchdogInterrupt==1) */
-					      /**************************/
 				/* Starts Watchdog/counter 3 */
-					      /**************************/
 				i_WatchdogCounter3Enabled = 1;
-						/********************************************/
 				/* Selects the commands and status register */
-						/********************************************/
 				outb(APCI1500_RW_CPT_TMR3_CMD_STATUS,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 				outb(i_CommandAndStatusValue,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
 			}	/*  if( i_WatchdogCounter3init==1) */
 			else {
 				dev_warn(dev->hw_dev,
 					"Watchdog/Counter3 not configured\n");
 				return -EINVAL;
 			}
 			break;
 
 		case STOP:
 
-					      /**************************/
 			/* Stop Watchdog/counter 3 */
-					      /**************************/
 
-						/********************************************/
 			/* Selects the commands and status register */
-						/********************************************/
 			outb(APCI1500_RW_CPT_TMR3_CMD_STATUS,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			outb(0x00,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			i_WatchdogCounter3Enabled = 0;
 			break;
 
 		case TRIGGER:
 			switch (data[2]) {
 			case 0:	/* triggering counter 3 */
 				if (i_WatchdogCounter3Init == 1) {
 					if (i_WatchdogCounter3Enabled == 1) {
-							       /************************/
 						/* Set Trigger and gate */
-							       /************************/
 
 						i_CommandAndStatusValue = 0x6;
 					}	/* if( i_WatchdogCounter3Enabled==1) */
 					else {
-							   /***************/
 						/* Set Trigger */
-							   /***************/
 
 						i_CommandAndStatusValue = 0x2;
 					}	/* elseif(i_WatchdogCounter3Enabled==1) */
 
-						/********************************************/
 					/* Selects the commands and status register */
-						/********************************************/
 					outb(APCI1500_RW_CPT_TMR3_CMD_STATUS,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 					outb(i_CommandAndStatusValue,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 				}	/* if( i_WatchdogCounter3Init==1) */
 				else {
 					dev_warn(dev->hw_dev,
 						"Counter3 not configured\n");
 					return -EINVAL;
 				}
 				break;
 			case 1:
 				/* triggering Watchdog 3 */
 				if (i_WatchdogCounter3Init == 1) {
 
-						/********************************************/
 					/* Selects the commands and status register */
-						/********************************************/
 					outb(APCI1500_RW_CPT_TMR3_CMD_STATUS,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 					outb(0x6,
 						devpriv->iobase +
 						APCI1500_Z8536_CONTROL_REGISTER);
 				}	/* if( i_WatchdogCounter3Init==1) */
 				else {
 					dev_warn(dev->hw_dev,
 						"Watchdog 3 not configured\n");
 					return -EINVAL;
 				}
 				break;
 			default:
 				dev_warn(dev->hw_dev,
 					"Wrong choice of watchdog/counter3\n");
 				return -EINVAL;
 			}	/* switch(data[2]) */
 			break;
 		default:
@@ -2266,171 +1976,147 @@ static int i_apci1500_timer_watchdog(struct comedi_device *dev,
 | Output Parameters :	--													 |
 +----------------------------------------------------------------------------+
 | Return Value      : TRUE  : No error occur                                 |
 |		            : FALSE : Error occur. Return the error          |
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
 static int i_APCI1500_ReadCounterTimerWatchdog(struct comedi_device *dev,
 					       struct comedi_subdevice *s,
 					       struct comedi_insn *insn,
 					       unsigned int *data)
 {
 	struct addi_private *devpriv = dev->private;
 	int i_CommandAndStatusValue;
 
 	switch (data[0]) {
 	case COUNTER1:
 		/* Read counter/timer1 */
 		if (i_TimerCounter1Init == 1) {
 			if (i_TimerCounter1Enabled == 1) {
-		  /************************/
 				/* Set RCC and gate */
-		  /************************/
 
 				i_CommandAndStatusValue = 0xC;
 			}	/* if( i_TimerCounter1Init==1) */
 			else {
-		    /***************/
 				/* Set RCC */
-		    /***************/
 
 				i_CommandAndStatusValue = 0x8;
 			}	/* elseif(i_TimerCounter1Init==1) */
 
-		/********************************************/
 			/* Selects the commands and status register */
-		/********************************************/
 			outb(APCI1500_RW_CPT_TMR1_CMD_STATUS,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			outb(i_CommandAndStatusValue,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 
-		 /***************************************/
 			/* Selects the counter register (high) */
-		 /***************************************/
 			outb(APCI1500_R_CPT_TMR1_VALUE_HIGH,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			data[0] =
 				inb(devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			data[0] = data[0] << 8;
 			data[0] = data[0] & 0xff00;
 			outb(APCI1500_R_CPT_TMR1_VALUE_LOW,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			data[0] =
 				data[0] | inb(devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 		}		/* if( i_TimerCounter1Init==1) */
 		else {
 			dev_warn(dev->hw_dev,
 				"Timer/Counter1 not configured\n");
 			return -EINVAL;
 		}		/* elseif( i_TimerCounter1Init==1) */
 		break;
 	case COUNTER2:
 		/* Read counter/timer2 */
 		if (i_TimerCounter2Init == 1) {
 			if (i_TimerCounter2Enabled == 1) {
-		  /************************/
 				/* Set RCC and gate */
-		  /************************/
 
 				i_CommandAndStatusValue = 0xC;
 			}	/* if( i_TimerCounter2Init==1) */
 			else {
-		    /***************/
 				/* Set RCC */
-		    /***************/
 
 				i_CommandAndStatusValue = 0x8;
 			}	/* elseif(i_TimerCounter2Init==1) */
 
-		/********************************************/
 			/* Selects the commands and status register */
-		/********************************************/
 			outb(APCI1500_RW_CPT_TMR2_CMD_STATUS,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			outb(i_CommandAndStatusValue,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 
-		 /***************************************/
 			/* Selects the counter register (high) */
-		 /***************************************/
 			outb(APCI1500_R_CPT_TMR2_VALUE_HIGH,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			data[0] =
 				inb(devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			data[0] = data[0] << 8;
 			data[0] = data[0] & 0xff00;
 			outb(APCI1500_R_CPT_TMR2_VALUE_LOW,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			data[0] =
 				data[0] | inb(devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 		}		/* if( i_TimerCounter2Init==1) */
 		else {
 			dev_warn(dev->hw_dev,
 				"Timer/Counter2 not configured\n");
 			return -EINVAL;
 		}		/* elseif( i_TimerCounter2Init==1) */
 		break;
 	case COUNTER3:
 		/* Read counter/watchdog2 */
 		if (i_WatchdogCounter3Init == 1) {
 			if (i_WatchdogCounter3Enabled == 1) {
-		  /************************/
 				/* Set RCC and gate */
-		  /************************/
 
 				i_CommandAndStatusValue = 0xC;
 			}	/* if( i_TimerCounter2Init==1) */
 			else {
-		    /***************/
 				/* Set RCC */
-		    /***************/
 
 				i_CommandAndStatusValue = 0x8;
 			}	/* elseif(i_WatchdogCounter3Init==1) */
 
-		/********************************************/
 			/* Selects the commands and status register */
-		/********************************************/
 			outb(APCI1500_RW_CPT_TMR3_CMD_STATUS,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			outb(i_CommandAndStatusValue,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 
-		 /***************************************/
 			/* Selects the counter register (high) */
-		 /***************************************/
 			outb(APCI1500_R_CPT_TMR3_VALUE_HIGH,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			data[0] =
 				inb(devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			data[0] = data[0] << 8;
 			data[0] = data[0] & 0xff00;
 			outb(APCI1500_R_CPT_TMR3_VALUE_LOW,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			data[0] =
 				data[0] | inb(devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 		}		/* if( i_WatchdogCounter3Init==1) */
 		else {
 			dev_warn(dev->hw_dev,
 				"WatchdogCounter3 not configured\n");
 			return -EINVAL;
 		}		/* elseif( i_WatchdogCounter3Init==1) */
@@ -2508,416 +2194,322 @@ static int i_APCI1500_ConfigureInterrupt(struct comedi_device *dev,
 	unsigned int ui_Status;
 	int i_RegValue;
 	int i_Constant;
 
 	devpriv->tsk_Current = current;
 	outl(0x0, devpriv->i_IobaseAmcc + 0x38);
 	if (data[0] == 1) {
 		i_Constant = 0xC0;
 	}			/* if(data[0]==1) */
 	else {
 		if (data[0] == 0) {
 			i_Constant = 0x00;
 		}		/* if{data[0]==0) */
 		else {
 			dev_warn(dev->hw_dev,
 				"The parameter passed to driver is in error for enabling the voltage interrupt\n");
 			return -EINVAL;
 		}		/* else if(data[0]==0) */
 	}			/* elseif(data[0]==1) */
 
-	 /*****************************************************/
 	/* Selects the mode specification register of port B */
-	 /*****************************************************/
 	outb(APCI1500_RW_PORT_B_SPECIFICATION,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	i_RegValue = inb(devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	outb(APCI1500_RW_PORT_B_SPECIFICATION,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-      /*********************************************/
 	/* Writes the new configuration (APCI1500_OR) */
-      /*********************************************/
 	i_RegValue = (i_RegValue & 0xF9) | APCI1500_OR;
 
 	outb(i_RegValue, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-       /*****************************************************/
 	/* Selects the command and status register of port B */
-       /*****************************************************/
 	outb(APCI1500_RW_PORT_B_COMMAND_AND_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-	/*****************************************/
 	/* Authorises the interrupt on the board */
-	/*****************************************/
 	outb(0xC0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-	/***************************************************/
 	/* Selects the pattern polarity register of port B */
-	/***************************************************/
 	outb(APCI1500_RW_PORT_B_PATTERN_POLARITY,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	outb(i_Constant, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-	/*****************************************************/
 	/* Selects the pattern transition register of port B */
-	/*****************************************************/
 	outb(APCI1500_RW_PORT_B_PATTERN_TRANSITION,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	outb(i_Constant, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-	/***********************************************/
 	/* Selects the pattern mask register of port B */
-	/***********************************************/
 	outb(APCI1500_RW_PORT_B_PATTERN_MASK,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	outb(i_Constant, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 
-	/*****************************************************/
 	/* Selects the command and status register of port A */
-	/*****************************************************/
 	outb(APCI1500_RW_PORT_A_COMMAND_AND_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	i_RegValue = inb(devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	outb(APCI1500_RW_PORT_A_COMMAND_AND_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-	 /***********************************/
 	/* Deletes the interrupt of port A */
-	 /***********************************/
 
 	i_RegValue = (i_RegValue & 0x0F) | 0x20;
 	outb(i_RegValue, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-	/*****************************************************/
 	/* Selects the command and status register of port  B */
-	/*****************************************************/
 	outb(APCI1500_RW_PORT_B_COMMAND_AND_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	i_RegValue = inb(devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	outb(APCI1500_RW_PORT_B_COMMAND_AND_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-	 /***********************************/
 	/* Deletes the interrupt of port B */
-	 /***********************************/
 
 	i_RegValue = (i_RegValue & 0x0F) | 0x20;
 	outb(i_RegValue, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 
-	/*****************************************************/
 	/* Selects the command and status register of timer 1 */
-	/*****************************************************/
 	outb(APCI1500_RW_CPT_TMR1_CMD_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	i_RegValue = inb(devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	outb(APCI1500_RW_CPT_TMR1_CMD_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-	 /***********************************/
 	/* Deletes the interrupt of timer 1 */
-	 /***********************************/
 
 	i_RegValue = (i_RegValue & 0x0F) | 0x20;
 	outb(i_RegValue, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 
-	 /*****************************************************/
 	/* Selects the command and status register of timer 2 */
-	/*****************************************************/
 	outb(APCI1500_RW_CPT_TMR2_CMD_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	i_RegValue = inb(devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	outb(APCI1500_RW_CPT_TMR2_CMD_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-	 /***********************************/
 	/* Deletes the interrupt of timer 2 */
-	 /***********************************/
 
 	i_RegValue = (i_RegValue & 0x0F) | 0x20;
 	outb(i_RegValue, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 
-	/*****************************************************/
 	/* Selects the command and status register of timer 3 */
-	/*****************************************************/
 	outb(APCI1500_RW_CPT_TMR3_CMD_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	i_RegValue = inb(devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	outb(APCI1500_RW_CPT_TMR3_CMD_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-	 /***********************************/
 	/* Deletes the interrupt of timer 3 */
-	 /***********************************/
 
 	i_RegValue = (i_RegValue & 0x0F) | 0x20;
 	outb(i_RegValue, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 
-	 /*************************************************/
 	/* Selects the master interrupt control register */
-	 /*************************************************/
 	outb(APCI1500_RW_MASTER_INTERRUPT_CONTROL,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-	/**********************************************/
 	/* Authorizes the main interrupt on the board */
-	/**********************************************/
 	outb(0xD0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 
-      /***************************/
 	/* Enables the PCI interrupt */
-      /*****************************/
 	outl(0x3000, devpriv->i_IobaseAmcc + 0x38);
 	ui_Status = inl(devpriv->i_IobaseAmcc + 0x10);
 	ui_Status = inl(devpriv->i_IobaseAmcc + 0x38);
 	outl(0x23000, devpriv->i_IobaseAmcc + 0x38);
 
 	return insn->n;
 }
 
 /*
 +----------------------------------------------------------------------------+
 | Function   Name   : static void v_APCI1500_Interrupt					     |
 |					  (int irq , void *d)      |
 +----------------------------------------------------------------------------+
 | Task              : Interrupt handler                                      |
 +----------------------------------------------------------------------------+
 | Input Parameters  : int irq                 : irq number                   |
 |                     void *d                 : void pointer                 |
 +----------------------------------------------------------------------------+
 | Output Parameters :	--													 |
 +----------------------------------------------------------------------------+
 | Return Value      : TRUE  : No error occur                                 |
 |		            : FALSE : Error occur. Return the error          |
 |			                                                         |
 +----------------------------------------------------------------------------+
 */
 static void v_APCI1500_Interrupt(int irq, void *d)
 {
 
 	struct comedi_device *dev = d;
 	struct addi_private *devpriv = dev->private;
 	unsigned int ui_InterruptStatus = 0;
 	int i_RegValue = 0;
 	i_InterruptMask = 0;
 
- /***********************************/
 	/* Read the board interrupt status */
- /***********************************/
 	ui_InterruptStatus = inl(devpriv->i_IobaseAmcc + 0x38);
 
-  /***************************************/
 	/* Test if board generated a interrupt */
-  /***************************************/
 	if ((ui_InterruptStatus & 0x800000) == 0x800000) {
-      /************************/
 		/* Disable all Interrupt */
-      /************************/
-      /*************************************************/
 		/* Selects the master interrupt control register */
-      /*************************************************/
 		/* outb(APCI1500_RW_MASTER_INTERRUPT_CONTROL,devpriv->iobase+APCI1500_Z8536_CONTROL_REGISTER); */
-	/**********************************************/
 		/* Disables  the main interrupt on the board */
-	/**********************************************/
 		/* outb(0x00,devpriv->iobase+APCI1500_Z8536_CONTROL_REGISTER); */
 
-   /*****************************************************/
 		/* Selects the command and status register of port A */
-   /*****************************************************/
 		outb(APCI1500_RW_PORT_A_COMMAND_AND_STATUS,
 			devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 		i_RegValue =
 			inb(devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 		if ((i_RegValue & 0x60) == 0x60) {
-	   /*****************************************************/
 			/* Selects the command and status register of port A */
-	   /*****************************************************/
 			outb(APCI1500_RW_PORT_A_COMMAND_AND_STATUS,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
-	    /***********************************/
 			/* Deletes the interrupt of port A */
-	    /***********************************/
 			i_RegValue = (i_RegValue & 0x0F) | 0x20;
 			outb(i_RegValue,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			i_InterruptMask = i_InterruptMask | 1;
 			if (i_Logic == APCI1500_OR_PRIORITY) {
 				outb(APCI1500_RW_PORT_A_SPECIFICATION,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 				i_RegValue =
 					inb(devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
-	      /***************************************************/
 				/* Selects the interrupt vector register of port A */
-	      /***************************************************/
 				outb(APCI1500_RW_PORT_A_INTERRUPT_CONTROL,
 					devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 				i_RegValue =
 					inb(devpriv->iobase +
 					APCI1500_Z8536_CONTROL_REGISTER);
 
 				i_InputChannel = 1 + (i_RegValue >> 1);
 
 			}	/*  if(i_Logic==APCI1500_OR_PRIORITY) */
 			else {
 				i_InputChannel = 0;
 			}	/* elseif(i_Logic==APCI1500_OR_PRIORITY) */
 		}		/*  if ((i_RegValue & 0x60) == 0x60) */
 
-	   /*****************************************************/
 		/* Selects the command and status register of port B */
-	   /*****************************************************/
 		outb(APCI1500_RW_PORT_B_COMMAND_AND_STATUS,
 			devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 		i_RegValue =
 			inb(devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 		if ((i_RegValue & 0x60) == 0x60) {
-	     /*****************************************************/
 			/* Selects the command and status register of port B */
-	     /*****************************************************/
 			outb(APCI1500_RW_PORT_B_COMMAND_AND_STATUS,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
-	     /***********************************/
 			/* Deletes the interrupt of port B */
-	     /***********************************/
 			i_RegValue = (i_RegValue & 0x0F) | 0x20;
 			outb(i_RegValue,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
-	     /****************/
 			/* Reads port B */
-	     /****************/
 			i_RegValue =
 				inb((unsigned int) devpriv->iobase +
 				APCI1500_Z8536_PORT_B);
 
 			i_RegValue = i_RegValue & 0xC0;
-	      /**************************************/
 			/* Tests if this is an external error */
-	      /**************************************/
 
 			if (i_RegValue) {
 				/* Disable the interrupt */
-		     /*****************************************************/
 				/* Selects the command and status register of port B */
-		     /*****************************************************/
 				outl(0x0, devpriv->i_IobaseAmcc + 0x38);
 
 				if (i_RegValue & 0x80) {
 					i_InterruptMask =
 						i_InterruptMask | 0x40;
 				}	/* if (i_RegValue & 0x80) */
 
 				if (i_RegValue & 0x40) {
 					i_InterruptMask =
 						i_InterruptMask | 0x80;
 				}	/* if (i_RegValue & 0x40) */
 			}	/*  if (i_RegValue) */
 			else {
 				i_InterruptMask = i_InterruptMask | 2;
 			}	/*  if (i_RegValue) */
 		}		/* if ((i_RegValue & 0x60) == 0x60) */
 
-		/*****************************************************/
 		/* Selects the command and status register of timer 1 */
-		/*****************************************************/
 		outb(APCI1500_RW_CPT_TMR1_CMD_STATUS,
 			devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 		i_RegValue =
 			inb(devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 		if ((i_RegValue & 0x60) == 0x60) {
-		   /*****************************************************/
 			/* Selects the command and status register of timer 1 */
-		   /*****************************************************/
 			outb(APCI1500_RW_CPT_TMR1_CMD_STATUS,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
-		   /***********************************/
 			/* Deletes the interrupt of timer 1 */
-		   /***********************************/
 			i_RegValue = (i_RegValue & 0x0F) | 0x20;
 			outb(i_RegValue,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			i_InterruptMask = i_InterruptMask | 4;
 		}		/*  if ((i_RegValue & 0x60) == 0x60) */
-		/*****************************************************/
 		/* Selects the command and status register of timer 2 */
-		/*****************************************************/
 		outb(APCI1500_RW_CPT_TMR2_CMD_STATUS,
 			devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 		i_RegValue =
 			inb(devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 		if ((i_RegValue & 0x60) == 0x60) {
-		   /*****************************************************/
 			/* Selects the command and status register of timer 2 */
-		   /*****************************************************/
 			outb(APCI1500_RW_CPT_TMR2_CMD_STATUS,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
-		   /***********************************/
 			/* Deletes the interrupt of timer 2 */
-		   /***********************************/
 			i_RegValue = (i_RegValue & 0x0F) | 0x20;
 			outb(i_RegValue,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			i_InterruptMask = i_InterruptMask | 8;
 		}		/*  if ((i_RegValue & 0x60) == 0x60) */
 
-		/*****************************************************/
 		/* Selects the command and status register of timer 3 */
-		/*****************************************************/
 		outb(APCI1500_RW_CPT_TMR3_CMD_STATUS,
 			devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 		i_RegValue =
 			inb(devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 		if ((i_RegValue & 0x60) == 0x60) {
-		   /*****************************************************/
 			/* Selects the command and status register of timer 3 */
-		   /*****************************************************/
 			outb(APCI1500_RW_CPT_TMR3_CMD_STATUS,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
-		   /***********************************/
 			/* Deletes the interrupt of timer 3 */
-		   /***********************************/
 			i_RegValue = (i_RegValue & 0x0F) | 0x20;
 			outb(i_RegValue,
 				devpriv->iobase +
 				APCI1500_Z8536_CONTROL_REGISTER);
 			if (i_CounterLogic == APCI1500_COUNTER) {
 				i_InterruptMask = i_InterruptMask | 0x10;
 			}	/* if(i_CounterLogic==APCI1500_COUNTER) */
 			else {
 				i_InterruptMask = i_InterruptMask | 0x20;
 			}
 		}		/*  if ((i_RegValue & 0x60) == 0x60) */
 
 		send_sig(SIGIO, devpriv->tsk_Current, 0);	/*  send signal to the sample */
-	       /***********************/
 		/* Enable all Interrupts */
-	       /***********************/
 
-	       /*************************************************/
 		/* Selects the master interrupt control register */
-	       /*************************************************/
 		outb(APCI1500_RW_MASTER_INTERRUPT_CONTROL,
 			devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-	       /**********************************************/
 		/* Authorizes the main interrupt on the board */
-	       /**********************************************/
 		outb(0xD0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	}			/*   if ((ui_InterruptStatus & 0x800000) == 0x800000) */
 	else {
 		dev_warn(dev->hw_dev,
 			"Interrupt from unknown source\n");
 
 	}			/* else if ((ui_InterruptStatus & 0x800000) == 0x800000) */
 	return;
 }
 
 /*
 +----------------------------------------------------------------------------+
 | Function   Name   : int i_APCI1500_Reset(struct comedi_device *dev)               |                                                       |
 +----------------------------------------------------------------------------+
 | Task              :resets all the registers                                |
 +----------------------------------------------------------------------------+
 | Input Parameters  : struct comedi_device *dev
 +----------------------------------------------------------------------------+
 | Output Parameters :	--													 |
 +----------------------------------------------------------------------------+
@@ -2927,224 +2519,180 @@ static void v_APCI1500_Interrupt(int irq, void *d)
 */
 static int i_APCI1500_Reset(struct comedi_device *dev)
 {
 	struct addi_private *devpriv = dev->private;
 	int i_DummyRead = 0;
 
 	i_TimerCounter1Init = 0;
 	i_TimerCounter2Init = 0;
 	i_WatchdogCounter3Init = 0;
 	i_Event1Status = 0;
 	i_Event2Status = 0;
 	i_TimerCounterWatchdogInterrupt = 0;
 	i_Logic = 0;
 	i_CounterLogic = 0;
 	i_InterruptMask = 0;
 	i_InputChannel = 0;
 	i_TimerCounter1Enabled = 0;
 	i_TimerCounter2Enabled = 0;
 	i_WatchdogCounter3Enabled = 0;
 
-    /******************/
 	/* Software reset */
-    /******************/
 	i_DummyRead = inb(devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	outb(0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	i_DummyRead = inb(devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	outb(0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	outb(1, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	outb(0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 
- /*****************************************************/
 	/* Selects the master configuration control register */
- /*****************************************************/
 	outb(APCI1500_RW_MASTER_CONFIGURATION_CONTROL,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	outb(0xF4, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 
-	/*****************************************************/
 	/* Selects the mode specification register of port A */
-	/*****************************************************/
 	outb(APCI1500_RW_PORT_A_SPECIFICATION,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	outb(0x10, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 
 	/* Selects the data path polarity register of port A */
 	outb(APCI1500_RW_PORT_A_DATA_PCITCH_POLARITY,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* High level of port A means 1 */
 	outb(0xFF, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 
 	/* Selects the data direction register of port A */
 	outb(APCI1500_RW_PORT_A_DATA_DIRECTION,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* All bits used as inputs */
 	outb(0xFF, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the command and status register of port A */
 	outb(APCI1500_RW_PORT_A_COMMAND_AND_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deletes IP and IUS */
 	outb(0x20, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/*  Selects the command and status register of port A */
 	outb(APCI1500_RW_PORT_A_COMMAND_AND_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deactivates the interrupt management of port A:  */
 	outb(0xE0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the handshake specification register of port A */
 	outb(APCI1500_RW_PORT_A_HANDSHAKE_SPECIFICATION,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deletes the register */
 	outb(0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 
-	 /*****************************************************/
 	/* Selects the mode specification register of port B */
-	 /*****************************************************/
 	outb(APCI1500_RW_PORT_B_SPECIFICATION,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	outb(0x10, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the data path polarity register of port B */
 	outb(APCI1500_RW_PORT_B_DATA_PCITCH_POLARITY,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* A high level of port B means 1 */
 	outb(0x7F, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the data direction register of port B */
 	outb(APCI1500_RW_PORT_B_DATA_DIRECTION,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* All bits used as inputs */
 	outb(0xFF, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the command and status register of port B */
 	outb(APCI1500_RW_PORT_B_COMMAND_AND_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deletes IP and IUS */
 	outb(0x20, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the command and status register of port B */
 	outb(APCI1500_RW_PORT_B_COMMAND_AND_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deactivates the interrupt management of port B:         */
 	outb(0xE0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the handshake specification register of port B */
 	outb(APCI1500_RW_PORT_B_HANDSHAKE_SPECIFICATION,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deletes the register */
 	outb(0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 
-	   /*****************************************************/
 	/* Selects the data path polarity register of port C */
-	   /*****************************************************/
 	outb(APCI1500_RW_PORT_C_DATA_PCITCH_POLARITY,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* High level of port C means 1 */
 	outb(0x9, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the data direction register of port C */
 	outb(APCI1500_RW_PORT_C_DATA_DIRECTION,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* All bits used as inputs except channel 1 */
 	outb(0x0E, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the special IO register of port C */
 	outb(APCI1500_RW_PORT_C_SPECIAL_IO_CONTROL,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deletes it */
 	outb(0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-	   /******************************************************/
 	/* Selects the command and status register of timer 1 */
-	   /******************************************************/
 	outb(APCI1500_RW_CPT_TMR1_CMD_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deletes IP and IUS */
 	outb(0x20, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the command and status register of timer 1 */
 	outb(APCI1500_RW_CPT_TMR1_CMD_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deactivates the interrupt management of timer 1         */
 	outb(0xE0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-	   /******************************************************/
 	/* Selects the command and status register of timer 2 */
-	   /******************************************************/
 	outb(APCI1500_RW_CPT_TMR2_CMD_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deletes IP and IUS */
 	outb(0x20, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the command and status register of timer 2 */
 	outb(APCI1500_RW_CPT_TMR2_CMD_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deactivates Timer 2 interrupt management:               */
 	outb(0xE0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-	  /******************************************************/
 	/* Selects the command and status register of timer 3 */
-	  /******************************************************/
 	outb(APCI1500_RW_CPT_TMR3_CMD_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deletes IP and IUS */
 	outb(0x20, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Selects the command and status register of Timer 3 */
 	outb(APCI1500_RW_CPT_TMR3_CMD_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deactivates interrupt management of timer 3:            */
 	outb(0xE0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-	 /*************************************************/
 	/* Selects the master interrupt control register */
-	 /*************************************************/
 	outb(APCI1500_RW_MASTER_INTERRUPT_CONTROL,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* Deletes all interrupts */
 	outb(0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	/* reset all the digital outputs */
 	outw(0x0, devpriv->i_IobaseAddon + APCI1500_DIGITAL_OP);
-/*******************************/
 /* Disable the board interrupt */
-/*******************************/
- /*************************************************/
 	/* Selects the master interrupt control register */
- /*************************************************/
 	outb(APCI1500_RW_MASTER_INTERRUPT_CONTROL,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-/****************************/
 /* Deactivates all interrupts */
-/******************************/
 	outb(0, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
- /*****************************************************/
 	/* Selects the command and status register of port A */
- /*****************************************************/
 	outb(APCI1500_RW_PORT_A_COMMAND_AND_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-/****************************/
 /* Deactivates all interrupts */
-/******************************/
 	outb(0x00, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-/*****************************************************/
 	/* Selects the command and status register of port B */
- /*****************************************************/
 	outb(APCI1500_RW_PORT_B_COMMAND_AND_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-/****************************/
 /* Deactivates all interrupts */
-/******************************/
 	outb(0x00, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-/*****************************************************/
 	/* Selects the command and status register of timer 1 */
- /*****************************************************/
 	outb(APCI1500_RW_CPT_TMR1_CMD_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-/****************************/
 /* Deactivates all interrupts */
-/******************************/
 	outb(0x00, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-/*****************************************************/
 	/* Selects the command and status register of timer 2 */
- /*****************************************************/
 	outb(APCI1500_RW_CPT_TMR2_CMD_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-/****************************/
 /* Deactivates all interrupts */
-/******************************/
 	outb(0x00, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-/*****************************************************/
 /* Selects the command and status register of timer 3*/
-/*****************************************************/
 	outb(APCI1500_RW_CPT_TMR3_CMD_STATUS,
 		devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
-/****************************/
 /* Deactivates all interrupts */
-/******************************/
 	outb(0x00, devpriv->iobase + APCI1500_Z8536_CONTROL_REGISTER);
 	return 0;
 }
-- 
1.8.5.3
